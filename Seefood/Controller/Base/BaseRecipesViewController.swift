//
//  BaseRecipesViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/22/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class BaseRecipesViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        UIApplication.shared.statusBarStyle = .default
        if let nav = navigationController?.navigationBar {
            nav.barTintColor = Constants.Colors().primaryColor
            nav.isTranslucent = true
            nav.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
            nav.tintColor = UIColor.black
        }
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        recipesData = calculateRecipes()
        recipesCollectionViewController.collectionView?.reloadData()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(1234)
        recipesData = calculateRecipes()
        DispatchQueue.main.async {
            self.recipesCollectionViewController.collectionView?.reloadData()
        }
    }
    
    // MARK: Should be overriden in child classes
    func calculateRecipes() -> [Recipe] {
        return [Recipe]()
    }
    var recipesData = [Recipe]()
    fileprivate var filtering = false
    fileprivate var filteredRecipes = [Recipe]()
    
    lazy var recipesCollectionViewController: RecipesCollectionViewController = {
        let layout = UICollectionViewFlowLayout()
        let vc = RecipesCollectionViewController(collectionViewLayout: layout)
        vc.recipesData = self.recipesData
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            self.filteredRecipes = self.recipesData.filter({ (recipe) -> Bool in
                return recipe.name.lowercased().contains(text.lowercased())
            })
            self.recipesCollectionViewController.recipesData = filteredRecipes
            self.filtering = true
        }
        else {
            self.filtering = false
            self.recipesCollectionViewController.recipesData = recipesData
            self.filteredRecipes.removeAll()
        }
        self.recipesCollectionViewController.collectionView?.reloadData()
    }
    
    func setupViews() {
        let containerView = view
        addChildViewController(recipesCollectionViewController)
        containerView?.addSubview(recipesCollectionViewController.view)
        recipesCollectionViewController.didMove(toParentViewController: self)
        
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "|-0-[v0]-0-|", options: [], metrics: nil, views: ["v0": recipesCollectionViewController.view]) +
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: [], metrics: nil, views: ["v0": recipesCollectionViewController.view])
            )
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.navigationItem.searchController?.searchBar.endEditing(true)
    }
    
}

