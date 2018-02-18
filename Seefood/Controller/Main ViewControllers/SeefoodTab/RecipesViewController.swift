//
//  RecipesViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/11/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    // TODO: color of search bar
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
        
        recipesCollectionView.dataSource = self
        recipesCollectionView.delegate = self
        recipesCollectionView.register(RecipeCell.self, forCellWithReuseIdentifier: cellId)
        recipesCollectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        calculateRecipes()
        recipesCollectionView.reloadData()
        setupViews()
    }
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    let recipesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.alwaysBounceVertical = true
        return view
    }()
    
    func setupViews() {
        view.addSubview(recipesCollectionView)
        
        NSLayoutConstraint.activate([
            recipesCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            recipesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            recipesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FoodData.calculatedRecipes.count
    }
    
    lazy var recipehandler: RecipeHandler = {
        let handler = RecipeHandler()
        return handler
    }()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RecipeCell
        let recipeAtIndex = FoodData.calculatedRecipes[indexPath.row]
        cell.recipe = recipeAtIndex
        cell.handleRecipeTap = {
            let recipeViewController = RecipeViewController()
            recipeViewController.title = cell.recipe?.name
            recipeViewController.recipeTableViewController.recipe = cell.recipe
            self.navigationController?.pushViewController(recipeViewController, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = recipesCollectionView.frame.width
        return CGSize(width: width, height: width * 0.56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = recipesCollectionView.frame.width
        return CGSize(width: width, height: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
            return header
        default:
            assert(false, "Not Header or Footer")
        }
    }
    
    func calculateRecipes() {
        
        var ingredients = [String]()
        for picture in FoodData.currentPictures {
            ingredients.append(picture.name.lowercased())
        }
        
        for recipe in FoodsKnown().allRecipes {
            let recipeIngredients = recipe.ingredients
            
            for neededIngredient in recipeIngredients {
                if ingredients.contains(neededIngredient.name) {
                    //recipeIngredients.index(of: neededIngredient) == recipeIngredients.count - 1 &&
                    var recipeListed = false
                    for suggestedRecipe in FoodData.calculatedRecipes {
                        if  suggestedRecipe == recipe {
                            recipeListed = true
                            break
                        }
                    }
                    if !recipeListed {
                        FoodData.calculatedRecipes.append(recipe)
                    }
                } else {
                    //break
                }
            }
        }
    }
    
}
