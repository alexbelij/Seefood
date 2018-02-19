//
//  AllRecipesViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/19/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import CoreData

// TODO: Customize AllRecipes and BookmarkedRecipes Controllers
class AllRecipesViewController: UIViewController {
    
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
            self.title = "All"
            nav.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
            self.navigationController?.navigationBar.tintColor = UIColor.black
            UIApplication.shared.statusBarStyle = .default
        }
    
        for recipe in FoodsKnown().allRecipes {
            savedRecipes.append(recipe)
        }
        
        setupViews()
    }
    
    var savedRecipes = [Recipe]()
    
    lazy var recipesCollectionViewController: RecipesCollectionViewController = {
        let layout = UICollectionViewFlowLayout()
        let vc = RecipesCollectionViewController(layout: layout, recipes: savedRecipes)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.backgroundColor = .red
        return vc
    }()
    
    func setupViews() {
        let containerView: UIView? = view
        addChildViewController(recipesCollectionViewController)
        containerView?.addSubview(recipesCollectionViewController.view)
        recipesCollectionViewController.didMove(toParentViewController: self)
        
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "|-0-[v0]-0-|", options: [], metrics: nil, views: ["v0": recipesCollectionViewController.view]) +
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: [], metrics: nil, views: ["v0": recipesCollectionViewController.view])
        )
    }
    
}
