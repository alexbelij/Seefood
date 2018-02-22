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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        recipeCategoriesTableView.dataSource = self
        recipeCategoriesTableView.delegate = self
        recipeCategoriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        recipeCategoriesTableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = false
        if let nav = navigationController?.navigationBar {
            nav.prefersLargeTitles = true
            nav.barTintColor = Constants.Colors().primaryColor
            nav.isTranslucent = false
            self.title = "Recipe Book"
        }
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
    
    func setupViews() {
        view.addSubview(recipeCategoriesTableView)
        
        NSLayoutConstraint.activate([
            recipeCategoriesTableView.topAnchor.constraint(equalTo: view.topAnchor),
            recipeCategoriesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            recipeCategoriesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipeCategoriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<SavedRecipes> = SavedRecipes.fetchRequest()
            do {
                let savedRecipes = try context.fetch(fetchRequest)
                for savedRecipe in savedRecipes {
                    let recipe = savedRecipe.recipe as! Recipe
                    print(recipe.name)
                }
                print("-----")
            } catch {
                print("rip saved recipe")
            }
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
