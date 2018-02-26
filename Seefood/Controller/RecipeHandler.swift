//
//  RecipeHandler.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/11/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class RecipeHandler: NSObject {
    
    override init() {
        super.init()
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(blurView)
            window.addSubview(baseView)
            window.addSubview(closeButton)
            baseView.addSubview(bodyView)
        }
    }
    
    var recipe: Recipe? {
        didSet {
            let recipe = self.recipe!
            recipeTitle.text = recipe.name
            descriptionBody.text = recipe.description
            ingredientsBody.text = recipe.getCommaRecipeString()
            recipeBody.text = recipe.recipeSteps.joined(separator: ", ")
        }
    }
    
    let descriptionTitle: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ingredientsTitle: UILabel = {
        let label = UILabel()
        label.text = "Ingredients"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let recipeTitle: UILabel = {
        let label = UILabel()
        label.text = "Recipe Title"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionBody: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ingredientsBody: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let recipeBody: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let recipeHeader: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bodyView: UIScrollView = {
        let view = UIScrollView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 50
        view.clipsToBounds = false
        
        view.clipsToBounds = false
        view.layer.shadowRadius = 7
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        view.layer.shadowOpacity = 0.75
        view.alpha = 0
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        if let image = UIImage(named: "ic_close_white")?.withRenderingMode(.alwaysTemplate) {
            button.setImage(image, for: .normal)
        }
        button.tintColor = .black
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupViews() {
//        view.addSubview(descriptionTitle)
//        view.addSubview(descriptionBody)
//        view.addSubview(ingredientsTitle)
//        view.addSubview(ingredientsBody)
//        view.addSubview(recipeTitle)
//        view.addSubview(recipeBody)
        
        if let window = UIApplication.shared.keyWindow {
            
            let windowMargin = window.safeAreaInsets
            NSLayoutConstraint.activate([
                blurView.topAnchor.constraint(equalTo: window.topAnchor),
                blurView.bottomAnchor.constraint(equalTo: window.bottomAnchor),
                blurView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                blurView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
                
                closeButton.topAnchor.constraint(equalTo: window.topAnchor, constant: 10 + windowMargin.top),
                closeButton.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 10 + windowMargin.bottom),
                closeButton.heightAnchor.constraint(equalToConstant: 30),
                closeButton.widthAnchor.constraint(equalToConstant: 30),
                
                bodyView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 20),
                bodyView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -20),
                bodyView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 20),
                bodyView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -20)
                ])
            baseView.frame = CGRect(x: 30, y: window.frame.maxY, width: window.frame.width - 60, height: window.frame.height - 80)
        }
        
        closeButton.addTarget(self, action: #selector(dismissRecipePopup), for: .touchUpInside)
    }
    
    func showRecipePopup() {
        setupViews()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blurView.alpha = 1
            self.closeButton.alpha = 1
            self.baseView.frame.origin.y = 40
            self.baseView.alpha = 1
        })
        print(baseView.frame)
    }
    
    @objc func dismissRecipePopup() {
        if let window = UIApplication.shared.keyWindow {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.blurView.alpha = 0
                self.closeButton.alpha = 0
                self.baseView.frame.origin.y = window.frame.maxY
                self.baseView.alpha = 0
            })
        }
    }
    
}
