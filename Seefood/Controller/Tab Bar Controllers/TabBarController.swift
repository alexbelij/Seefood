//
//  TabBarController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/16/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cameraViewController = CameraViewController()
        let cameraNavigationController = UINavigationController(rootViewController: cameraViewController)
        
        let recipeBookViewController = RecipeBookViewController()
        let recipeBookNavigationController = UINavigationController(rootViewController: recipeBookViewController)
        
        let vcData: [(vc: UIViewController, image: UIImage, title: String)] = [
            (cameraNavigationController, UIImage(named: "ic_camera_alt")!, "Seefood"),
            (recipeBookNavigationController, UIImage(named: "ic_book")!, "Recipe Book")]
        
        var tabViewControllers: [UIViewController] = []
        for item in vcData {
            item.vc.tabBarItem.image = item.image.withRenderingMode(.alwaysTemplate)
            item.vc.tabBarItem.title = item.title
            item.vc.tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: -3, bottom: -2, right: -3)
            tabViewControllers.append(item.vc)
        }
        
        /*let backgroundView = UIImageView(image: UIImage(named: "black_gradient"))
        backgroundView.isOpaque = false
        backgroundView.contentMode = .scaleToFill
        var tabBarFrame = tabBar.frame.size
        backgroundView.frame.size = tabBarFrame
        
        tabBar.addSubview(backgroundView)
        tabBar.backgroundImage = UIImage(color: .clear)*/
        
        tabBar.barStyle = UIBarStyle.black
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.tintColor = Constants.Colors().primaryColor
        
        tabBar.layer.borderWidth = 0
        tabBar.clipsToBounds = true
        
        viewControllers = tabViewControllers
        selectedIndex = 0
    }
    
}
