//
//  LoadingViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/10/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadingCircle.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        UIApplication.shared.statusBarStyle = .default
        //self.tabBarController?.tabBar.isHidden = false
        
        
        foodIdentifier = FoodIdentification()
        foodIdentifier.foodsIdentified = {
//            let ingredientsViewController = IngredientsViewController()
//            let transition = CATransition()
//            transition.duration = 0.5
//            transition.type = kCATransitionPush
//            transition.subtype = kCATransitionFromRight
//            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
//            self.view.window!.layer.add(transition, forKey: kCATransition)
//            self.present(UINavigationController(rootViewController: ingredientsViewController), animated: false, completion: nil)
            self.navigationController?.pushViewController(IngredientsViewController(), animated: true)
        }
        
//        FoodData.guessedFoods.removeAll()
//        for _ in 0...FoodData.currentPictures.count {
//            FoodData.guessedFoods.append("")
//        }

        for (index, imagePair) in  FoodData.currentPictures.enumerated() {
            foodIdentifier.queue = foodIdentifier.queue + 1
            foodIdentifier.updateClassifications(for: imagePair.image, index: index)
        }
        
        view.backgroundColor = Constants.Colors().primaryColor
    }
    
    lazy var foodIdentifier: FoodIdentification = {
        let identifier = FoodIdentification()
        return identifier
    }()
    
}
