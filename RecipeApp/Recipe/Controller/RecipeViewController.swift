//
//  RecipeViewController.swift
//  RecipeApp
//
//  Created by Nate Goh on 14/11/2020.
//  Copyright © 2020 Nate Goh. All rights reserved.
//

import UIKit

protocol RecipeViewControllerDelegate: AnyObject {
    func reloadRecipes()
}

class RecipeViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    internal lazy var recipeViewModel: RecipeViewModel = { [weak self] in
        return RecipeViewModel()
    }()

    weak var delegate: RecipeViewControllerDelegate?
    private var recipeType: String = ""

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        initCommon()
        setupTableView()
        setupNavigationBar()
        setupRecipeTypes()
        fetchData()
    }

    private func initCommon() {
        delegate = self
    }

    private func fetchData() {
        recipeViewModel.fetchData(recipeType: recipeType)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: RecipeCell.cellId, bundle: nil), forCellReuseIdentifier: RecipeCell.cellId)
    }

    private func setupNavigationBar() {
        let addRecipeButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createButtonWasTapped))
        let filterRecipeButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterButtonWasTapped))
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonWasTapped))
        self.navigationItem.rightBarButtonItems = [logoutButton, addRecipeButton, filterRecipeButton]
    }

    private func setupRecipeTypes() {
        if let path = Bundle.main.url(forResource: "RecipeTypes", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = recipeViewModel
                parser.parse()
            }
        }
    }
}

extension RecipeViewController {
    @objc private func createButtonWasTapped() {
        let vc = AddRecipeViewController()
        vc.delegate = delegate
        vc.viewModel = recipeViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func filterButtonWasTapped() {
        let alert = UIAlertController(title: "Apply filter", message: "", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "None", style: .default , handler:{ (UIAlertAction) in
            self.recipeType = ""
            self.fetchData()
        }))

        for recipeType in recipeViewModel.getRecipesTypes() {
            alert.addAction(UIAlertAction(title: recipeType.type ?? "", style: .default , handler:{ (UIAlertAction)in
                self.recipeType = recipeType.type ?? ""
                self.fetchData()
            }))
        }
        self.present(alert, animated: true, completion: nil)
    }

    @objc private func logoutButtonWasTapped() {
        UserController.shared.logout()
        let vc = AuthViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

extension RecipeViewController: RecipeViewControllerDelegate {
    func reloadRecipes() {
        fetchData()
    }
}

extension RecipeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeViewModel.getRecipes().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCell.cellId, for: indexPath) as? RecipeCell {
            cell.recipe = recipeViewModel.getRecipes()[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddRecipeViewController()
        vc.viewModel = recipeViewModel
        vc.action = .edit
        vc.delegate = delegate
        vc.recipe = recipeViewModel.getRecipes()[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
