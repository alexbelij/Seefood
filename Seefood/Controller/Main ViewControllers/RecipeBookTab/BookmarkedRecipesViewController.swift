//
//  BookmarkedRecipesViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/19/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import CoreData

class BookmarkedRecipesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if let nav = navigationController?.navigationBar {
            let searchController = UISearchController(searchResultsController: nil)
            navigationItem.searchController = searchController
            //navigationItem.hidesSearchBarWhenScrolling = false
            nav.barTintColor = Constants.Colors().primaryColor
            nav.isTranslucent = false
            self.title = "Bookmarked"
            nav.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
            self.navigationController?.navigationBar.tintColor = UIColor.black
            UIApplication.shared.statusBarStyle = .default
        }
        refreshData()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshData()
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
    
    func refreshData() {
        recipes.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<SavedRecipes> = SavedRecipes.fetchRequest()
        do {
            let savedRecipes = try context.fetch(fetchRequest)
            for savedRecipe in savedRecipes {
                recipes.append(savedRecipe.recipe as! Recipe)
            }
        } catch { }
    }
    
    func setupViews() {
        view.addSubview(recipesViewController)
        NSLayoutConstraint.activate([
            recipesViewController.topAnchor.constraint(equalTo: view.topAnchor),
            recipesViewController.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            recipesViewController.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipesViewController.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
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


//class BookmarkedRecipesViewController: UIViewController {
//
//    // TODO: color of search bar
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        if let nav = navigationController?.navigationBar {
//            let searchController = UISearchController(searchResultsController: nil)
//            navigationItem.searchController = searchController
//            //navigationItem.hidesSearchBarWhenScrolling = false
//            nav.barTintColor = Constants.Colors().primaryColor
//            nav.isTranslucent = false
//            self.title = "Bookmarked"
//            nav.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
//            self.navigationController?.navigationBar.tintColor = UIColor.black
//            UIApplication.shared.statusBarStyle = .default
//        }
//
//        refreshBookmarkedRecipeData()
//        setupViews()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        refreshBookmarkedRecipeData()
//    }
//
//    func refreshBookmarkedRecipeData() {
//        savedRecipes.removeAll()
//
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<SavedRecipes> = SavedRecipes.fetchRequest()
//        do {
//            let recipes = try context.fetch(fetchRequest)
//            for recipe in recipes {
//                if let aRecipe = recipe.recipe as? Recipe {
//                    savedRecipes.append(aRecipe)
//                }
//            }
//        } catch {
//            print("Failed saved recipes fetch request")
//        }
//        recipesCollectionViewController.recipeSource = savedRecipes
//        recipesCollectionViewController.collectionView?.reloadData()
//    }
//
//    var savedRecipes = [Recipe]()
//
//    lazy var recipesCollectionViewController: RecipesCollectionViewController = {
//        let layout = UICollectionViewFlowLayout()
//        let vc = RecipesCollectionViewController(layout: layout, recipes: savedRecipes, containingParent: self)
//        vc.view.translatesAutoresizingMaskIntoConstraints = false
//        vc.view.backgroundColor = .red
//        return vc
//    }()
//
//    func setupViews() {
//        let containerView: UIView? = view
//        addChildViewController(recipesCollectionViewController)
//        containerView?.addSubview(recipesCollectionViewController.view)
//        recipesCollectionViewController.didMove(toParentViewController: self)
//
//        NSLayoutConstraint.activate(
//            NSLayoutConstraint.constraints(withVisualFormat: "|-0-[v0]-0-|", options: [], metrics: nil, views: ["v0": recipesCollectionViewController.view]) +
//                NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: [], metrics: nil, views: ["v0": recipesCollectionViewController.view])
//        )
//    }
//
//}

