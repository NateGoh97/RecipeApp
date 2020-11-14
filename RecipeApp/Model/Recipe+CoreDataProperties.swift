//
//  Recipe+CoreDataProperties.swift
//  RecipeApp
//
//  Created by Nate Goh on 14/11/2020.
//  Copyright © 2020 Nate Goh. All rights reserved.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var title: String?
    @NSManaged public var recipeType: String?
    @NSManaged public var thumbnail: Data?
    @NSManaged public var steps: String?
    @NSManaged public var ingredients: [String]?

}
