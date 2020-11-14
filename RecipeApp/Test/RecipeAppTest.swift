//
//  RecipeAppTest.swift
//  RecipeAppTests
//
//  Created by Nate Goh on 14/11/2020.
//  Copyright © 2020 Nate Goh. All rights reserved.
//

import XCTest
@testable import RecipeApp

class RecipeAppTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testRecipeViewModel() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let recipe = Recipe(context: context)
        recipe.title = "Nasi Lemak"
        recipe.ingredients = ["Sugar", "Coconut milk"]
        recipe.steps = "Step 1: Prepare..."
        recipe.thumbnail = #imageLiteral(resourceName: "testImage").pngData()
        let recipeArray = [recipe]
        let recipeViewModel = RecipeViewModel(recipes: recipeArray)

        XCTAssertEqual(recipe.title, recipeViewModel.getRecipes()[0].title)
        XCTAssertEqual(recipe.ingredients, recipeViewModel.getRecipes()[0].ingredients)
        XCTAssertEqual(recipe.steps, recipeViewModel.getRecipes()[0].steps)
        XCTAssertEqual(recipe.thumbnail, recipeViewModel.getRecipes()[0].thumbnail)
    }

    func testConvertIngredientsIsSuccess() {
        let vc = AddRecipeViewController()
        let ingredients = "Sugar, Oil, Salt"
        let ingredientArray = ["Sugar", "Oil", "Salt"]
        let convertedIngredientArray = vc.convertIngredientsToArray(ingredients: ingredients)

        XCTAssertEqual(ingredientArray, convertedIngredientArray)
    }

}
