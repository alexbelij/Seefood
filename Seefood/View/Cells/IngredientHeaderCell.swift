//
//  IngredientHeaderCell.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/14/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class IngredientHeaderCell: BaseTableViewCell {
    
    var exportButtonTapped: (()->())?
    var name: String? {
        didSet {
            ingredientLabel.text = name
        }
    }

    var ingredientLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Demibold", size: 25)
        label.textColor = Constants.Colors().secondaryColor
        return label
    }()
    
    let exportButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = false
        button.backgroundColor = .white //Constants.Colors().secondaryColor
        button.setTitleColor(Constants.Colors().secondaryColor, for: .normal)
        button.setTitle("Export", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext", size: 13)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1.2
        button.layer.borderColor = Constants.Colors().secondaryColor.cgColor
        return button
    }()
    
    override func setupViews() {
        self.addSubview(ingredientLabel)
        self.addSubview(exportButton)
        self.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            
            self.heightAnchor.constraint(equalToConstant: 70),
            
            ingredientLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            ingredientLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            ingredientLabel.widthAnchor.constraint(equalToConstant: 200),
            
            exportButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            exportButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            exportButton.widthAnchor.constraint(equalToConstant: 73),
            exportButton.heightAnchor.constraint(equalToConstant: 37)
            
            ])
        
        exportButton.addTarget(self, action: #selector(handleExportButtonTapped), for: .touchUpInside)
        
        self.isUserInteractionEnabled = true
    }
    
    @objc func handleExportButtonTapped() {
        exportButtonTapped?()
    }
    
}
