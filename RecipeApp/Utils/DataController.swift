//
//  DataController.swift
//  RecipeApp
//
//  Created by Nate Goh on 14/11/2020.
//  Copyright © 2020 Nate Goh. All rights reserved.
//

import UIKit
import CoreData

class DataController {
    static let shared = DataController()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func fetchRecipe(recipeType: String, completion: @escaping ([Recipe], Error?) -> Void) {
        do {
            let request = Recipe.fetchRequest() as NSFetchRequest<Recipe>
            if(!recipeType.isEmpty) {
                let predict = NSPredicate(format: "recipeType Contains '\(recipeType)'")
                request.predicate = predict
            }
            let recipe: [Recipe] = try context.fetch(request)
            completion(recipe, nil)
        } catch {
//            Handle error
        }
    }

    func saveRecipe(title: String, ingredients: [String], steps: String, data: Data, recipeType: String) {
        let recipe = Recipe(context: self.context)
        recipe.title = title
        recipe.ingredients = ingredients
        recipe.steps = steps
        recipe.thumbnail = data
        recipe.recipeType = recipeType

        do {
            try self.context.save()
        } catch {
//            catch error
        }
    }

    func editRecipe(title: String, ingredients: [String], steps: String, data: Data, recipeType: String, recipe: Recipe) {
        recipe.title = title
        recipe.ingredients = ingredients
        recipe.steps = steps
        recipe.thumbnail = data
        recipe.recipeType = recipeType
        do{
            try self.context.save()
        } catch {
            //Do something
        }
    }

    func deleteRecipe(recipe: Recipe) {
        self.context.delete(recipe)

        do {
            try self.context.save()
        } catch {
//            catch error
        }
    }
}
