//
//  TabBarController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/16/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

// TODO: camera and loading views are constrained above tab; need to be whole window

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cameraViewController = CameraViewController()
        let cameraNavigationController = UINavigationController(rootViewController: cameraViewController)
        
        let recipeBookViewController = RecipeBookViewController()
        let recipeBookNavigationController = UINavigationController(rootViewController: recipeBookViewController)
        
        let vcData: [(vc: UIViewController, image: UIImage, title: String)] = [
            (cameraNavigationController, UIImage(named: "ic_camera_alt")!, "Seefood"),
            (recipeBookNavigationController, UIImage(named: "ic_bookmark")!, "Recipe Book")]
        
        var tabViewControllers: [UIViewController] = []
        for item in vcData {
            item.vc.tabBarItem.image = item.image.withRenderingMode(.alwaysTemplate)
            item.vc.tabBarItem.title = item.title
            tabViewControllers.append(item.vc)
        }
        
        tabBar.isTranslucent = true
        tabBar.barTintColor = Constants.Colors().primaryColor
        tabBar.tintColor = Constants.Colors().secondaryDarkColor
        
        viewControllers = tabViewControllers
        selectedIndex = 0
    }
    
}
