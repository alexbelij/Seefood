//
//  RecipeBookViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/16/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import CoreData

class RecipeBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        if let nav = navigationController?.navigationBar {
            nav.prefersLargeTitles = true
            nav.barTintColor = .white //Constants.Colors().primaryColor
            nav.tintColor = Constants.Colors().secondaryColor
            nav.isTranslucent = true
            self.title = "Recipe Book"
        }
        recipeCategoriesTableView.dataSource = self
        recipeCategoriesTableView.delegate = self
        recipeCategoriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        recipeCategoriesTableView.reloadData()
        
        let button = UIButton()
        if let image = UIImage(named: "ic_settings")?.withRenderingMode(.alwaysTemplate) {
            button.setImage(image, for: .normal)
        }
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.setRightBarButton(barButton, animated: true)

        setupViews()
    }
    
    let recipeCategories = ["Bookmarked", "All"]
    let cellId = "cellId"
    
    lazy var recipeCategoriesTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var settingsContainer: UIView = {
        let view = UIView()
        let settingsViewController = SettingsViewController()
        let navController = UINavigationController(rootViewController: settingsViewController)
        view.addSubview(navController.view)
        navController.didMove(toParentViewController: self)
        return view
    }()
    
    func setupViews() {
        view.addSubview(recipeCategoriesTableView)
        
        NSLayoutConstraint.activate([
            recipeCategoriesTableView.topAnchor.constraint(equalTo: view.topAnchor),
            recipeCategoriesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            recipeCategoriesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipeCategoriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    
    @objc func settingsButtonTapped() {
        self.tabBarController?.present(UINavigationController(rootViewController: SettingsViewController()), animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(BookmarkedRecipesViewController(), animated: true)
        case 1:
            self.navigationController?.pushViewController(AllRecipesViewController(), animated: true)
        default:
            assert(false, "Wrong table view indexPath.row")
        }
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = recipeCategories[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
