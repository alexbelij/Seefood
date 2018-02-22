//
//  BaseLargeTitleViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/21/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

// TODO: Implement this further
class BaseLargeTitleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        if let nav = navigationController?.navigationBar {
            //let searchController = UISearchController(searchResultsController: nil)
            //navigationItem.searchController = searchController
            //navigationItem.hidesSearchBarWhenScrolling = false
            nav.barTintColor = Constants.Colors().primaryColor
            nav.isTranslucent = false
            //self.title = "Base Controller"
            nav.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
            self.navigationController?.navigationBar.tintColor = UIColor.black
            UIApplication.shared.statusBarStyle = .default
        }
        
        setupViews()
    }
    
    func setupViews() {
        
    }
    
}
