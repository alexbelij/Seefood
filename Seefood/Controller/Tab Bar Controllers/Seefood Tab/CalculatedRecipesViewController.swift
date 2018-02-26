//
//  CalculatedRecipesViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/21/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class CalculatedRecipesViewController: BaseRecipesViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Recipes"
    }
    
    override func calculateRecipes() -> [Recipe] {
        var recipes = [Recipe]()
        var ingredients = [String]()
        for picture in FoodData.currentPictures {
            ingredients.append(picture.name.lowercased())
        }
        let userDefaults = UserDefaults.standard
        let restricted = userDefaults.object(forKey: "limited_recipes") as! Bool
        for recipe in FoodsKnown().allRecipes {
            let recipeIngredients = recipe.ingredients
            if !restricted {
                for neededIngredient in recipeIngredients {
                    if ingredients.contains(neededIngredient.name) {
                        recipes.append(recipe)
                    }
                }
            } else {
                var containsAll: Bool = true
                for neededIngredient in recipeIngredients {
                    if !ingredients.contains(neededIngredient.name) {
                        containsAll = false
                        break
                    }
                }
                if containsAll {
                    recipes.append(recipe)
                }
            }
        }
        return recipes
    }
    
}
