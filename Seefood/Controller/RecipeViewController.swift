//
//  RecipeViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/12/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import CoreData

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
    
    override func viewDidAppear(_ animated: Bool) {
        updateBookmarkButton()
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
        updateBookmarkButton()
    }
    
    func updateBookmarkButton() {
        
        let bookmarkButton = UIButton()
        bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTouchUpInside), for: .touchUpInside)
        let bookmarkBarButton = UIBarButtonItem(customView: bookmarkButton)
        
        let shareImage = UIImage(named: "ic_check_white")?.withRenderingMode(.alwaysTemplate)
        let shareButton = UIButton()
        shareButton.setImage(shareImage, for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonTouchUpInside), for: .touchUpInside)
        let shareBarButton = UIBarButtonItem(customView: shareButton)
        
        let recipe = self.recipeTableViewController.recipe!
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<SavedRecipes> = SavedRecipes.fetchRequest()
        var bookmarked = false
        do {
            let savedRecipes = try context.fetch(fetchRequest)
            for savedRecipe in savedRecipes {
                if recipe.isEqual(savedRecipe.recipe as? Recipe) {
                    print("\((savedRecipe.recipe as! Recipe).name) : \(recipe.name)")
                    bookmarked = true
                    break
                }
            }
        } catch {
            print("rip saved recipe")
        }
        
        let bookmarkImage = UIImage(named: bookmarked ? "ic_bookmark_white" : "ic_bookmark_border_white")?.withRenderingMode(.alwaysTemplate)
        bookmarkButton.setImage(bookmarkImage, for: .normal)
        
        navigationItem.setRightBarButtonItems([bookmarkBarButton, shareBarButton], animated: bookmarked)
        
    }
    
    @objc func bookmarkButtonTouchUpInside() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<SavedRecipes> = SavedRecipes.fetchRequest()
        
        let recipe = self.recipeTableViewController.recipe!
        do {
            let savedRecipes = try context.fetch(fetchRequest)
            var found = false
            for savedRecipe in savedRecipes {
                let aRecipe = savedRecipe.recipe as! Recipe
                found = (recipe.isEqual(aRecipe))
                if found {
                    context.delete(savedRecipe)
                    updateBookmarkButton()
                    break
                }
            }
            
            if !found {
                let entity = NSEntityDescription.entity(forEntityName: "SavedRecipes", in: context)
                let newSavedRecipe = NSManagedObject(entity: entity!, insertInto: context)
                newSavedRecipe.setValue(recipe, forKey: "recipe")
                do {
                    try context.save()
                    updateBookmarkButton()
                } catch {
                    print("Save failed")
                }
            }
        } catch { }
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
    
}
