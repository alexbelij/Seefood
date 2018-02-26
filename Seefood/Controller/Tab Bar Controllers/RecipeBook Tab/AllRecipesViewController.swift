//
//  AllRecipesViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/19/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class AllRecipesViewController: BaseRecipesViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All"
    }
    
    override func calculateRecipes() -> [Recipe] {
        var recipes = [Recipe]()
        for recipe in FoodsKnown().allRecipes {
            recipes.append(recipe)
        }
        return recipes
    }
    
}
