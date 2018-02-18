//
//  ProcedureHeaderCell.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/15/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class ProcedureHeaderCell: BaseTableViewCell {
    
    var name: String? {
        didSet {
            procedureLabel.text = self.name
        }
    }
    
    let procedureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Demibold", size: 25)
        label.textColor = Constants.Colors().secondaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupViews() {
        self.addSubview(procedureLabel)
        self.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 70),

            procedureLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            procedureLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            procedureLabel.widthAnchor.constraint(equalToConstant: 200),
            ])
        
        self.isUserInteractionEnabled = false
    }
    
}
