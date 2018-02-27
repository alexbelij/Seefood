//
//  PreviewPictureCell.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/7/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class PreviewPictureCell: BaseCollectionViewCell {
    
    var picture: UIImage? {
        didSet {
            pictureImageView.image = picture
        }
    }
    
    var deletePressed: (()->())?
    
    let deleteImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        if let image = UIImage(named: "ic_close_white") {
            button.setImage(image, for: .normal)
        }
        button.clipsToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let pictureImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        return view
    }()
    
    let containingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    override func setupViews() {
        self.addSubview(containingView)
        containingView.addSubview(pictureImageView)
        self.addSubview(deleteImageButton)
        
        let deleteButtonRadius: CGFloat = 30
        deleteImageButton.layer.cornerRadius = deleteButtonRadius / 2
        deleteImageButton.addTarget(self, action: #selector(onDeletePressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            containingView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            containingView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containingView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containingView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
            
            pictureImageView.topAnchor.constraint(equalTo: containingView.topAnchor),
            pictureImageView.bottomAnchor.constraint(equalTo: containingView.bottomAnchor),
            pictureImageView.leadingAnchor.constraint(equalTo: containingView.leadingAnchor),
            pictureImageView.trailingAnchor.constraint(equalTo: containingView.trailingAnchor),
            
            deleteImageButton.topAnchor.constraint(equalTo: self.topAnchor),
            deleteImageButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            deleteImageButton.heightAnchor.constraint(equalToConstant: deleteButtonRadius),
            deleteImageButton.widthAnchor.constraint(equalToConstant: deleteButtonRadius)
            
            ])
        
    }
    
    @objc func onDeletePressed() {
        deletePressed?()
    }
    
}

