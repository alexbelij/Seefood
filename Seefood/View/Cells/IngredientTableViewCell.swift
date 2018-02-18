//
//  IngredientTableViewCell.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/15/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class IngredientTableViewCell: BaseTableViewCell {
    
    var name: String? {
        didSet {
            ingredientName.text = name
        }
    }
    
    var amount: String? {
        didSet {
            ingredientAmount.text = amount
        }
    }
    
    let ingredientName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Regular", size: 17)
        //label.backgroundColor = .green
        return label
    }()
    
    let ingredientAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Regular", size: 15)
        //label.backgroundColor = .yellow
        return label
    }()
    
    override func setupViews() {
        self.addSubview(ingredientName)
        self.addSubview(ingredientAmount)
        
        NSLayoutConstraint.activate([
            
            self.heightAnchor.constraint(equalToConstant: 45),
            
            ingredientName.topAnchor.constraint(equalTo: self.topAnchor),
            ingredientName.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ingredientName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 35),
            ingredientName.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            
            ingredientAmount.topAnchor.constraint(equalTo: self.topAnchor),
            ingredientAmount.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ingredientAmount.leadingAnchor.constraint(equalTo: ingredientName.trailingAnchor),
            ingredientAmount.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            
            ])
        
        self.isUserInteractionEnabled = false
    }
    
}
