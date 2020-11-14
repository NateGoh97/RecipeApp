//
//  RecipeViewModel.swift
//  RecipeApp
//
//  Created by Nate Goh on 14/11/2020.
//  Copyright © 2020 Nate Goh. All rights reserved.
//

import Foundation

class RecipeViewModel: NSObject {

    override init() {
        super.init()
    }

    init(recipes: [Recipe]) {
        self.recipes = recipes
    }

    private var recipes: [Recipe] = []
    private var recipeTypes: [RecipeType] = []
    private var elementName = String()

    func fetchData(recipeType: String) {
        DataController.shared.fetchRecipe(recipeType: recipeType) { (recipes, error) in
            if let _ = error {
//                catch error
                return
            }
            self.recipes = recipes
        }
    }

    func saveRecipe(title: String, ingredients: [String], steps: String, data: Data, recipeType: String) {
        DataController.shared.saveRecipe(title: title, ingredients: ingredients, steps: steps, data: data, recipeType: recipeType)
    }

    func editRecipe(title: String, ingredients: [String], steps: String, data: Data, recipeType: String, recipe: Recipe) {
         DataController.shared.editRecipe(title: title, ingredients: ingredients, steps: steps, data: data, recipeType: recipeType, recipe: recipe)
    }

    func deleteRecipe(recipe: Recipe) {
        DataController.shared.deleteRecipe(recipe: recipe)
    }
}

extension RecipeViewModel {
    func getRecipes() -> [Recipe] {
        return recipes
    }

    func getRecipesTypes() -> [RecipeType] {
        return recipeTypes
    }
}

extension RecipeViewModel: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.elementName = elementName
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if self.elementName == "RecipeType" {
                let recipeType = RecipeType(type: data)
                recipeTypes.append(recipeType)
            }
        }
    }
}
