//
//  BookmarkedRecipesViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/19/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import CoreData

class BookmarkedRecipesViewController: BaseRecipesViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bookmarked"
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
    }
    
    override func calculateRecipes() -> [Recipe] {
        var recipes = [Recipe]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<SavedRecipes> = SavedRecipes.fetchRequest()
        do {
            let savedRecipes = try context.fetch(fetchRequest)
            for savedRecipe in savedRecipes {
                recipes.append(savedRecipe.recipe as! Recipe)
            }
        } catch { }
        return recipes
    }
    
}
