//
//  IngredientCell.swift
//  FoodRecipeV2
//
//  Created by Siddha Tiwari on 2/10/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class IngredientCell: BaseCollectionViewCell, UITextViewDelegate {
    
    var picture: UIImage? {
        didSet {
            pictureImageView.image = picture
        }
    }
    
    var name: String? {
        didSet {
            ingredientName.text = name
        }
    }
    
    var ingredientLabelChanged: ((_ text: String)->())?
    
    let pictureImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        return view
    }()
    
    let ingredientName: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.75)
        textView.textColor = .white
        textView.textAlignment = .center
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = .byTruncatingHead
        textView.font = UIFont(name: "AvenirNext-Demibold", size: 17)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.clipsToBounds = true
        return textView
    }()
    
    // TODO: fix shadow
    let containingView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        
        view.clipsToBounds = true
        
//        view.layer.shadowRadius = 15
//        view.layer.shadowColor = UIColor.darkGray.cgColor
//        view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//        view.layer.shadowOpacity = 0.75
//
        view.layer.cornerRadius = 15
        
        let shadow: CAShapeLayer =  {
            let shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: 10).cgPath
            //shadowLayer.fillColor = UIColor.white.cgColor

            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 10
            return shadowLayer
        }()
        
        //view.layer.addSublayer(shadow)
        //view.layer.sublayers![0].masksToBounds = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupViews() {
        self.addSubview(containingView)
        containingView.addSubview(pictureImageView)
        containingView.addSubview(ingredientName)
        
        NSLayoutConstraint.activate([
            
            containingView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            containingView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            containingView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            containingView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            pictureImageView.topAnchor.constraint(equalTo: containingView.topAnchor),
            pictureImageView.leadingAnchor.constraint(equalTo: containingView.leadingAnchor),
            pictureImageView.trailingAnchor.constraint(equalTo: containingView.trailingAnchor),
            pictureImageView.bottomAnchor.constraint(equalTo: containingView.bottomAnchor),
            
            //ingredientName.topAnchor.constraint(equalTo: pictureImageView.bottomAnchor),
            ingredientName.heightAnchor.constraint(equalToConstant: 40),
            ingredientName.leadingAnchor.constraint(equalTo: containingView.leadingAnchor),
            ingredientName.trailingAnchor.constraint(equalTo: containingView.trailingAnchor),
            ingredientName.bottomAnchor.constraint(equalTo: containingView.bottomAnchor)
            
            ])
        
        self.backgroundColor = .white
        self.isUserInteractionEnabled = true
        ingredientName.delegate = self
        pictureImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pictureTapped)))
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pictureTapped)))
    }
    
    @objc func pictureTapped() {
        if ingredientName.isFirstResponder {
            self.ingredientName.resignFirstResponder()
        } else {
            self.ingredientName.becomeFirstResponder()
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        containingView.expand(scale: 1.05)
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        containingView.expand(scale: 1)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.rangeOfCharacter(from: CharacterSet.newlines) == nil {
            return true
        }
        else if text == "\n" {
            ingredientLabelChanged?(text)
            textView.resignFirstResponder()
            return false
        }
        return false;
    }
    
}
