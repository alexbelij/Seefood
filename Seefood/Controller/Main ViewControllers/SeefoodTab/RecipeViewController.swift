//
//  RecipeViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/12/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit


class RecipeViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        if let nav = navigationController?.navigationBar {
            nav.barTintColor = Constants.Colors().primaryColor
            nav.isTranslucent = false
            nav.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
            self.navigationController?.navigationBar.tintColor = UIColor.black
            UIApplication.shared.statusBarStyle = .default
        }
        setupViews()
        setupNavBarButtons()
    }
    
    lazy var recipeTableViewController: RecipeTableViewController = {
        let vc = RecipeTableViewController()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    func setupViews() {
        let containerView: UIView? = view
        addChildViewController(recipeTableViewController)
        containerView?.addSubview(recipeTableViewController.view)
        recipeTableViewController.didMove(toParentViewController: self)
        
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "|-0-[v0]-0-|", options: [], metrics: nil, views: ["v0": recipeTableViewController.view]) +
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: [], metrics: nil, views: ["v0": recipeTableViewController.view])
        )
    }
    
    func setupNavBarButtons() {
        let bookmarkImage = UIImage(named: "ic_bookmark_border_white")?.withRenderingMode(.alwaysTemplate)
        let bookmarkButton = UIButton()
        bookmarkButton.setImage(bookmarkImage, for: .normal)
        bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTouchUpInside), for: .touchUpInside)
        let bookmarkBarButton = UIBarButtonItem(customView: bookmarkButton)
        
        let shareImage = UIImage(named: "ic_check_white")?.withRenderingMode(.alwaysTemplate)
        let shareButton = UIButton()
        shareButton.setImage(shareImage, for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonTouchUpInside), for: .touchUpInside)
        let shareBarButton = UIBarButtonItem(customView: shareButton)
        
        navigationItem.setRightBarButtonItems([bookmarkBarButton, shareBarButton], animated: true)
    }
    
    @objc func bookmarkButtonTouchUpInside() {
        
    }
    
    @objc func shareButtonTouchUpInside() {
        let recipe = self.recipeTableViewController.recipe!
        
        var textToExport = "\(recipe.name)\n\n"
        textToExport.append("\(recipe.description)\n\nIngredients\n\n")
        for item in recipe.ingredients {
            textToExport.append("\(item.amount) \(item.name)\n")
        }
        textToExport.append("\nProcedure\n\n")
        for (index, item) in recipe.recipeSteps.enumerated() {
            textToExport.append("\(index + 1).\t\(item)\n")
        }
        
        let activityVC = UIActivityViewController(activityItems: [textToExport], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
//    let recipeTableViewController: RecipeTableViewController = {
//        let tv = RecipeTableViewController()
//        tv.view.translatesAutoresizingMaskIntoConstraints = false
//        return tv
//    }()
    
}
