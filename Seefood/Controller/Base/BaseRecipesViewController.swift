//
//  BaseRecipesViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/22/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class BaseRecipesViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        view.backgroundColor = .red
        UIApplication.shared.statusBarStyle = .default
        if let nav = navigationController?.navigationBar {
            nav.barTintColor = .white
            nav.isTranslucent = true
            nav.tintColor = Constants.Colors().secondaryColor
        }
        recipesData = calculateRecipes()
        if recipesCollectionViewController.getNumberOfData() > 0 {
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.searchBar.tintColor = Constants.Colors().secondaryColor
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            setupNavBarButtons()
        }
        recipesCollectionViewController.collectionView?.reloadData()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recipesData = calculateRecipes()
        DispatchQueue.main.async {
            self.recipesCollectionViewController.collectionView?.reloadData()
        }
    }
    
    func setupNavBarButtons() {
        let button = UIButton()
        button.clipsToBounds = false
        button.backgroundColor = .clear
        button.setTitleColor(Constants.Colors().secondaryColor, for: .normal)
        button.setTitle("Filter", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext", size: 8)
        button.layer.borderColor = Constants.Colors().secondaryColor.cgColor
        button.addTarget(self, action: #selector(filterButtonTouchUpInside), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.setRightBarButton(barButtonItem, animated: true)
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
            self.recipesCollectionViewController.recipesData = calculateRecipes()
            self.filteredRecipes.removeAll()
        }
        self.recipesCollectionViewController.collectionView?.reloadData()
    }
    
    @objc func filterButtonTouchUpInside() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationItem.searchController?.searchBar.endEditing(true)
    }
    
}

