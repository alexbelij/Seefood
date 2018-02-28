//
//  RecipeCell.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/11/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import CoreData

class RecipeCell: BaseCollectionViewCell {
    
    var recipe: Recipe? {
        didSet {
            let recipe = self.recipe!
            recipeImageView.image = UIImage(named: recipe.imageName)
            recipeName.text = recipe.name
            recipeIngredients.text = recipe.getCommaRecipeString()
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<SavedRecipes> = SavedRecipes.fetchRequest()
            do {
                let savedRecipes = try context.fetch(fetchRequest)
                for savedRecipe in savedRecipes {
                    let cellRecipe = self.recipe!
                    if cellRecipe.isEqual(savedRecipe.recipe as? Recipe) {
                        print("\((savedRecipe.recipe as! Recipe).name) : \(cellRecipe.name)")
                        bookmarkButton.setImage(UIImage(named: "ic_bookmark_white"), for: .normal)
                        break
                    }
                }
            } catch {
                print("rip saved recipe")
            }
        }
    }
    
    var handleRecipeTap: (()->())?
    var handleBookmarkTap: (() throws ->())?
    
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.cornerRadius = 15
        return view
    }()
    
    let recipeName: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont(name: "AvenirNext-Bold", size: 30)
        label.textColor = .white
        label.isUserInteractionEnabled = false
        return label
    }()
    
    let recipeIngredients: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont(name: "AvenirNext-Regular", size: 15)
        label.isUserInteractionEnabled = false
        return label
    }()
    
    let recipeInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = Constants.Colors().primaryColor
        return view
    }()
    
    let recipeImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.cornerRadius = 15
        return view
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.Colors().secondaryColor
        if let notSavedImage = UIImage(named: "ic_bookmark_border_white") {
            button.setImage(notSavedImage, for: .normal)
        }
        button.layer.cornerRadius = 20
        button.clipsToBounds = false
        button.layer.shadowRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let containingView: UIView = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.layer.shadowRadius = 10
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.75
        return view
    }()
    
    let interactionLayer: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.backgroundColor = .clear
        return button
    }()
    
    override func setupViews() {
        self.addSubview(containingView)
        containingView.addSubview(recipeImageView)
        containingView.addSubview(blurView)
        containingView.addSubview(recipeName)
        containingView.addSubview(interactionLayer)
        containingView.addSubview(bookmarkButton)
        
        NSLayoutConstraint.activate([
            containingView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            containingView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containingView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            containingView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            recipeImageView.topAnchor.constraint(equalTo: containingView.topAnchor),
            recipeImageView.bottomAnchor.constraint(equalTo: containingView.bottomAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: containingView.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: containingView.trailingAnchor),
            
            blurView.topAnchor.constraint(equalTo: containingView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: containingView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: containingView.trailingAnchor),
            blurView.heightAnchor.constraint(equalToConstant: 60),
            
            recipeName.topAnchor.constraint(equalTo: containingView.topAnchor, constant: 15),
            recipeName.leadingAnchor.constraint(equalTo: containingView.leadingAnchor, constant: 15),
            
            interactionLayer.topAnchor.constraint(equalTo: containingView.topAnchor),
            interactionLayer.bottomAnchor.constraint(equalTo: containingView.bottomAnchor),
            interactionLayer.leadingAnchor.constraint(equalTo: containingView.leadingAnchor),
            interactionLayer.trailingAnchor.constraint(equalTo: containingView.trailingAnchor),
            
            bookmarkButton.bottomAnchor.constraint(equalTo: containingView.bottomAnchor, constant: -15),
            bookmarkButton.trailingAnchor.constraint(equalTo: containingView.trailingAnchor, constant: -15),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 40),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 40),
            ])
        
        interactionLayer.addTarget(self, action: #selector(containingViewTouchDown), for: .touchDown)
        interactionLayer.addTarget(self, action: #selector(containingViewTouchUpOutside), for: .touchUpOutside)
        interactionLayer.addTarget(self, action: #selector(containingViewTouchUpInside), for: .touchUpInside)
        
        bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTouchDown), for: .touchDown)
        bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTouchUpOutside), for: .touchUpOutside)
        bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTouchUpInside), for: .touchUpInside)
        //recipeView.addGestureRecognizer(UIgesture)
        
    }
    
    // MARK: THIS IS WHAT I NEEDED
    override func prepareForReuse() {
        UIView.animate(withDuration: 0, animations: {
            self.containingView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        bookmarkButton.setImage(UIImage(named: "ic_bookmark_border_white"), for: .normal)
    }
    
    @objc func bookmarkButtonTouchDown() {
        
    }
    
    @objc func bookmarkButtonTouchUpOutside() {
        
    }
    
    @objc func bookmarkButtonTouchUpInside() {
        do {
            try handleBookmarkTap?()
        } catch {
            print("error")
        }
    }
    
    @objc func containingViewTouchDown() {
        containingView.expand(scale: 0.95)
    }
    
    @objc func containingViewTouchUpOutside() {
        containingView.expand(scale: 1)
    }
    
    @objc func containingViewTouchUpInside() {
        containingView.expand(scale: 1)
        handleRecipeTap?()
    }
    
}
