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
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
    }
    
    override func calculateRecipes() -> [Recipe] {
        var recipes = [Recipe]()
        var ingredients = [String]()
        for picture in FoodData.currentPictures {
            ingredients.append(picture.name.lowercased())
        }
        for recipe in FoodsKnown().allRecipes {
            let recipeIngredients = recipe.ingredients
            for neededIngredient in recipeIngredients {
                if ingredients.contains(neededIngredient.name) {
                    recipes.append(recipe)
                }
            }
        }
        return recipes
    }
    
}
