//
//  LoadingViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/10/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import SpriteKit

class LoadingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default
        
        foodIdentifier = FoodIdentification()
        foodIdentifier.foodsIdentified = {
            self.navigationController?.pushViewController(IngredientsViewController(), animated: true)
        }

        for (index, imagePair) in  FoodData.currentPictures.enumerated() {
            foodIdentifier.queue = foodIdentifier.queue + 1
            foodIdentifier.updateClassifications(for: imagePair.image, index: index)
        }
        
        view.backgroundColor = Constants.Colors().primaryColor
        
        setupViews()
        showAnimate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disappearAnimate()
    }
    
    lazy var foodIdentifier: FoodIdentification = {
        let identifier = FoodIdentification()
        return identifier
    }()
    
    let loadingText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Loading"
        label.font = UIFont(name: "AvenirNext-Bold", size: 50)
        return label
    }()
    
    func setupViews() {
        view.addSubview(loadingText)
        
        NSLayoutConstraint.activate([
            loadingText.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            loadingText.heightAnchor.constraint(equalToConstant: 60),
            loadingText.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingText.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    
    func showAnimate() {
        loadingText.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        loadingText.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.loadingText.alpha = 1.0
            self.loadingText.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func disappearAnimate() {
        UIView.animate(withDuration: 0.2, animations: {
            self.loadingText.alpha = 0.0
            self.loadingText.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        })
    }
    
}
