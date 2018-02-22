//
//  BaseRecipesViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/22/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class BaseRecipesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if let nav = navigationController?.navigationBar {
            nav.barTintColor = Constants.Colors().primaryColor
            nav.isTranslucent = false
            nav.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
            nav.tintColor = UIColor.black
            UIApplication.shared.statusBarStyle = .default
        }
        
        recipesData = calculateRecipes()
        recipesCollectionViewController.collectionView?.reloadData()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recipesData = calculateRecipes()
        recipesCollectionViewController.collectionView?.reloadData()
    }
    
    // MARK: Should be implemented in child classes
    func calculateRecipes() -> [Recipe] {
        return [Recipe]()
    }
    
    var recipesData = [Recipe]()
    
    lazy var recipesCollectionViewController: UICollectionViewController = {
        let layout = UICollectionViewFlowLayout()
        let vc = RecipesCollectionViewController(collectionViewLayout: layout)
        vc.recipesData = self.recipesData
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
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
    
}
