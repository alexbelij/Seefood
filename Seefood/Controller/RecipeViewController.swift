//
//  RecipeViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/12/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import CoreData

class BookmarkAlert: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        self.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textLabel.heightAnchor.constraint(equalToConstant: 44)
            ])
    }
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "AvenirNext-Bold", size: 15)
        label.textAlignment = .center
        return label
    }()
    
    func show(hasBookmarked: Bool) {
        if hasBookmarked {
            textLabel.text = "Saved to Bookmarked Recipes"
            self.backgroundColor = Constants.Colors().secondaryColor
        } else {
            textLabel.text = "Removed from Bookmarked Recipes"
            self.backgroundColor = .red
        }
        UIView.animate(withDuration: 0.1, animations: {
            self.frame.origin = CGPoint(x: 0, y: 0)
        }, completion: { completed in
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(900), execute: {
                self.hide()
            })
        })
    }
    
    func hide() {
        UIView.animate(withDuration: 0.1, animations: {
            self.frame.origin = CGPoint(x: 0, y: -self.frame.height)
        })
    }
    
    func updateFrame(frame: CGRect) {
        self.frame = frame
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class RecipeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if let nav = navigationController?.navigationBar {
            nav.barTintColor = .white
            nav.isTranslucent = true
            nav.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
            nav.tintColor = Constants.Colors().secondaryColor
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
    
    var bookmarkAlert: BookmarkAlert? {
        didSet {
            guard let window = UIApplication.shared.keyWindow else {
                assert(false, "Window missing")
            }
            window.addSubview(bookmarkAlert!)
        }
    }
    
    func setupViews() {
        let containerView: UIView? = view
        addChildViewController(recipeTableViewController)
        containerView?.addSubview(recipeTableViewController.view)
        recipeTableViewController.didMove(toParentViewController: self)
        
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "|-0-[v0]-0-|", options: [], metrics: nil, views: ["v0": recipeTableViewController.view]) +
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: [], metrics: nil, views: ["v0": recipeTableViewController.view])
        )
        
        bookmarkAlert = BookmarkAlert()
        updateBookmarkAlertFrame()
    }
    
    func setupNavBarButtons() {
        updateBookmarkButton()
    }
    
    //TODO: figure out how to get height of small type navbar in program (the 44 value), and not when its large too
    func updateBookmarkAlertFrame() {
        guard let window = UIApplication.shared.keyWindow /*let navBar = navigationController?.navigationBar*/ else {
            assert(false, "Window missing")
        }
        let alertHeight = 44 + UIApplication.shared.statusBarFrame.height
        let alertFrame = CGRect(x: 0, y: -alertHeight, width: window.frame.width, height: alertHeight)
        bookmarkAlert?.updateFrame(frame: alertFrame)
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
        var isBookmarked = false
        do {
            let savedRecipes = try context.fetch(fetchRequest)
            for savedRecipe in savedRecipes {
                if recipe.isEqual(savedRecipe.recipe as? Recipe) {
                    print("\((savedRecipe.recipe as! Recipe).name) : \(recipe.name)")
                    isBookmarked = true
                    break
                }
            }
        } catch {
            print("rip saved recipe")
        }
        
        let bookmarkImage = UIImage(named: isBookmarked ? "ic_bookmark_white" : "ic_bookmark_border_white")?.withRenderingMode(.alwaysTemplate)
        bookmarkButton.setImage(bookmarkImage, for: .normal)
        
        navigationItem.setRightBarButtonItems([bookmarkBarButton, shareBarButton], animated: true)
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
            bookmarkAlert?.show(hasBookmarked: !found)
        } catch { }
    }
    
    @objc func shareButtonTouchUpInside() {
        let recipe = self.recipeTableViewController.recipe!
        
        var textToExport = "\(recipe.name)\n\n"
        textToExport.append("\(recipe.recipeDescription)\n\nIngredients\n\n")
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
