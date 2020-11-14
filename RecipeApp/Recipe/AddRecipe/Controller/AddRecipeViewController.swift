//
//  AddRecipeViewController.swift
//  RecipeApp
//
//  Created by Nate Goh on 14/11/2020.
//  Copyright © 2020 Nate Goh. All rights reserved.
//

import UIKit

enum Action {
    case create, edit
}

class AddRecipeViewController: UIViewController {

    @IBOutlet private weak var createButton: UIButton!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var ingredientsTextField: UITextField!
    @IBOutlet private weak var uploadButton: UIButton!
    @IBOutlet private weak var previewImageView: UIImageView!
    @IBOutlet private weak var stepsTextView: UITextView!
    @IBOutlet private weak var pickerView: UIPickerView!

    var action: Action = .create
    var recipe: Recipe?
    weak var delegate: RecipeViewControllerDelegate?
    var viewModel: RecipeViewModel?

    private var recipeType = "Breakfast"

    override func viewDidLoad() {
        super.viewDidLoad()
        initCommon()
        setupNavigationBar()
        setupGestureRecognizer()
        setupUIPickerView()
        setupRecipe()
    }
}

extension AddRecipeViewController {
    private func initCommon() {
        previewImageView.isHidden = true

        titleTextField.delegate = self
        ingredientsTextField.delegate = self
        stepsTextView.delegate = self

        createButton.backgroundColor = .lightGray
        createButton.setTitleColor(.white, for: .normal)

        stepsTextView.layer.borderColor = UIColor.black.cgColor
        stepsTextView.layer.borderWidth = 0.5

        previewImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.clipsToBounds = true

        createButton.isEnabled = false
        createButton.setTitle(action == .create ? "Create Recipe" : "Update Recipe", for: .normal)
    }

    private func setupGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(gestureRecognizer)
    }

    private func setupUIPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    private func setupRecipe() {
        switch action {
        case .edit:
            titleTextField.text = recipe?.title ?? ""
            ingredientsTextField.text = recipe?.ingredients?.joined(separator: ",")
            stepsTextView.text = recipe?.steps ?? ""
            if let image = UIImage(data: recipe?.thumbnail ?? Data()) {
                self.previewImageView.isHidden = false
                self.previewImageView.image = image
            }
            recipeType = recipe?.recipeType ?? ""
            switchToSelectedPickerView()
            validateUserInput()
        default:
            return
        }
    }

    private func setupNavigationBar() {
        if action == .edit {
            let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonWasTapped))
            navigationItem.rightBarButtonItem = deleteButton
        }
    }

    private func switchToSelectedPickerView() {
        let index = viewModel?.getRecipesTypes().firstIndex{ $0.type == self.recipeType } ?? 0
        pickerView.selectRow(index, inComponent: 0, animated: true)
    }

    func validateUserInput() {
        guard let title = titleTextField.text, let ingredients = ingredientsTextField.text, let steps = stepsTextView.text else { return }
        if title.isEmpty || ingredients.isEmpty || steps.isEmpty || previewImageView.image == nil {
            createButton.isEnabled = false
            createButton.backgroundColor = .lightGray
            return
        } else {
            createButton.isEnabled = true
            createButton.backgroundColor = .orange
        }
    }

    func convertIngredientsToArray(ingredients: String) -> [String] {
        let tempIngredients = ingredients.split(separator: ",")
        var ingredientArray: [String] = []
        for ingredient in tempIngredients {
            ingredientArray.append(ingredient.trimmingCharacters(in: .whitespaces))
        }
        return ingredientArray
    }
}

/// Actions
extension AddRecipeViewController {
    @IBAction func uploadButtonWasTapped(_ sender: UIButton) {
        getImage(fromSourceType: .photoLibrary, mediaTypes: ["public.image"])
    }

    @IBAction func createButtonWasTapped(_ sender: UIButton) {

        guard let title = titleTextField.text, let ingredients = ingredientsTextField.text, let steps = stepsTextView.text, let imageData = previewImageView.image?.pngData() else { return }
            let ingredientArray = convertIngredientsToArray(ingredients: ingredients)
            switch action {
            case .create:
                viewModel?.saveRecipe(title: title, ingredients: ingredientArray, steps: steps, data: imageData, recipeType: recipeType)
            case .edit:
                guard let recipe = recipe else { return }
                viewModel?.editRecipe(title: title, ingredients: ingredientArray, steps: steps, data: imageData, recipeType: recipeType, recipe: recipe)
            }
        self.delegate?.reloadRecipes()
        self.navigationController?.popViewController(animated: true)

    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func deleteButtonWasTapped() {
        if let recipe = recipe {
            viewModel?.deleteRecipe(recipe: recipe)
            delegate?.reloadRecipes()
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension AddRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            self.previewImageView.isHidden = false
            previewImageView.image = pickedImage
            validateUserInput()
        }
        dismiss(animated: true, completion: nil)
    }

    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType, mediaTypes: [String]) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            imagePickerController.allowsEditing = true
            imagePickerController.mediaTypes = mediaTypes
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
}

/// TextField Did Change
extension AddRecipeViewController: UITextFieldDelegate {
    @IBAction func titleTextFieldDidChanged(_ sender: UITextField) {
        validateUserInput()
    }
    @IBAction func ingredientsTextFieldDidChanged(_ sender: UITextField)
    {
        validateUserInput()
    }
}

extension AddRecipeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        validateUserInput()
    }
}

/// PickerView
extension AddRecipeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let viewModel = viewModel {
            return viewModel.getRecipesTypes().count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let viewModel = viewModel {
            return viewModel.getRecipesTypes()[row].type
        }
        return ""
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        recipeType = viewModel?.getRecipesTypes()[row].type ?? ""
    }
}
