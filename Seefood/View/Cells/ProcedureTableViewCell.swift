//
//  ProcedureTableViewCell.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/15/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class ProcedureTableViewCell: BaseTableViewCell {
    
    var number: Int? {
        didSet {
            if let n = number {
                numberLabel.text = "\(n)."
            }
        }
    }
    
    var stepText: String? {
        didSet {
            stepLabel.text = stepText
        }
    }
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Demibold", size: 20)
        //label.backgroundColor = .green
        return label
    }()
    
    let stepLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Regular", size: 17)
        label.numberOfLines = 0
        //label.backgroundColor = .yellow
        return label
    }()
    
    override func setupViews() {
        self.addSubview(numberLabel)
        self.addSubview(stepLabel)
        
        NSLayoutConstraint.activate([
            
            self.heightAnchor.constraint(equalTo: stepLabel.heightAnchor, constant: 30),
            
            numberLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            numberLabel.widthAnchor.constraint(equalToConstant: 40),
            numberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 35),
            
            stepLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            stepLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor),
            stepLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            
            ])
        
        self.isUserInteractionEnabled = false
    }
    
}
