//
//  IngredientCell.swift
//  Seefood
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
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.cornerRadius = 15
        return view
    }()
    
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.cornerRadius = 15
        return view
    }()
    
    let ingredientName: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = .byTruncatingHead
        textView.font = UIFont(name: "AvenirNext-Demibold", size: 17)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.clipsToBounds = true
        textView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        textView.layer.cornerRadius = 15
        return textView
    }()
    
    let containingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = false
        view.layer.shadowRadius = 10
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.75
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupViews() {
        self.addSubview(containingView)
        containingView.addSubview(pictureImageView)
        containingView.addSubview(blurView)
        containingView.addSubview(ingredientName)
        
        NSLayoutConstraint.activate([
            
            containingView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            containingView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            containingView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            containingView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            blurView.bottomAnchor.constraint(equalTo: containingView.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: containingView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: containingView.trailingAnchor),
            blurView.heightAnchor.constraint(equalToConstant: 40),
            
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
        
        self.backgroundColor = .clear
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
        self.expand(scale: 1.05)
        self.layer.zPosition = 999
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.expand(scale: 1)
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
