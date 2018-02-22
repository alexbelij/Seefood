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
                for saveRecipe in savedRecipes {
                    let cellRecipe = self.recipe!
                    if let savedImage = UIImage(named: "ic_bookmark_white") {
                        if cellRecipe.isEqual(saveRecipe.recipe as? Recipe) {
                            bookmarkButton.setImage(savedImage, for: .normal)
                            saved = true
                            break
                        }
                    }
                }
            } catch {
                print("rip saved recipe")
            }
        }
    }
    
    var handleRecipeTap: (()->())?
    var handleBookmarkTap: (() throws ->())?
    var saved = false
    
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
    
    // TODO: Vertically align to top
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
        view.backgroundColor = .red
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let containingView: UIView = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
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
        containingView.addSubview(recipeName)
        containingView.addSubview(interactionLayer)
        self.addSubview(bookmarkButton)
        
        NSLayoutConstraint.activate([
            
            containingView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            containingView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containingView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            containingView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            recipeImageView.topAnchor.constraint(equalTo: containingView.topAnchor),
            recipeImageView.bottomAnchor.constraint(equalTo: containingView.bottomAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: containingView.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: containingView.trailingAnchor),
            
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
