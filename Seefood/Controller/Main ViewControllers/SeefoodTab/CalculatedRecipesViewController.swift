//
//  CalculatedRecipesViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/21/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import CoreData

class CalculatedRecipesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if let nav = navigationController?.navigationBar {
            let searchController = UISearchController(searchResultsController: nil)
            navigationItem.searchController = searchController
            //navigationItem.hidesSearchBarWhenScrolling = false
            nav.barTintColor = Constants.Colors().primaryColor
            nav.isTranslucent = false
            self.title = "Recipes"
            nav.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
            self.navigationController?.navigationBar.tintColor = UIColor.black
            UIApplication.shared.statusBarStyle = .default
        }
        calculateRecipes()
        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        calculateRecipes()
        recipesViewController.reloadData()
    }

    let cellId = "cellId"
    var recipes = [Recipe]()

    lazy var recipesViewController: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let vc = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vc.delegate = self
        vc.dataSource = self
        vc.register(RecipeCell.self, forCellWithReuseIdentifier: cellId)
        vc.translatesAutoresizingMaskIntoConstraints = false
        vc.backgroundColor = .white
        return vc
    }()

    func setupViews() {
        view.addSubview(recipesViewController)
        NSLayoutConstraint.activate([
            recipesViewController.topAnchor.constraint(equalTo: view.topAnchor),
            recipesViewController.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            recipesViewController.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipesViewController.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }

    func calculateRecipes() {
        recipes.removeAll()
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
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RecipeCell
        cell.recipe = recipes[indexPath.row]
        cell.handleRecipeTap = {
            let recipeViewController = RecipeViewController()
            recipeViewController.title = cell.recipe?.name
            recipeViewController.recipeTableViewController.recipe = cell.recipe
            self.navigationController?.pushViewController(recipeViewController, animated: true)
        }
        cell.handleBookmarkTap = {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<SavedRecipes> = SavedRecipes.fetchRequest()
            let savedRecipes = try context.fetch(fetchRequest)
            
            var found = false
            for savedRecipe in savedRecipes {
                let aRecipe = savedRecipe.recipe as! Recipe
                found = (cell.recipe?.isEqual(aRecipe))!
                if found {
                    context.delete(savedRecipe)
                    cell.bookmarkButton.setImage(UIImage(named: "ic_bookmark_border_white"), for: .normal)
                    break
                }
            }
            
            if !found {
                let entity = NSEntityDescription.entity(forEntityName: "SavedRecipes", in: context)
                let newSavedRecipe = NSManagedObject(entity: entity!, insertInto: context)
                newSavedRecipe.setValue(cell.recipe, forKey: "recipe")
                do {
                    try context.save()
                    cell.bookmarkButton.setImage(UIImage(named: "ic_bookmark_white"), for: .normal)
                    cell.saved = true
                } catch {
                    print("Save failed")
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: width * 0.56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

