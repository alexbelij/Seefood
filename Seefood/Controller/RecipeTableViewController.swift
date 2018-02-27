//
//  RecipeTableViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/14/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class RecipeTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(IngredientHeaderCell.self, forCellReuseIdentifier: ingredientHeaderId)
        tableView.register(IngredientTableViewCell.self, forCellReuseIdentifier: ingredientCellId)
        tableView.register(ProcedureHeaderCell.self, forCellReuseIdentifier: procedureHeaderId)
        tableView.register(ProcedureTableViewCell.self, forCellReuseIdentifier: procedureCellId)
        tableView.separatorInset.left = 0
        tableView.separatorStyle = .none
        setupViews()
    }
    
    let headerId = "headerId"
    let ingredientHeaderId = "ingredientHeaderId"
    let ingredientCellId = "ingredientCellId"
    let procedureHeaderId = "procedureHeaderId"
    let procedureCellId = "procedureCellId"
    private var headerHeight: CGFloat? = 0
    
    var recipe: Recipe? {
        didSet {
            let recipe = self.recipe!
            var ingredientAndAmount = [String]()
            for r in recipe.ingredients {
                // MARK: ingredient and amount combined into one string
                ingredientAndAmount.append("\(r.name);\(r.amount)")
            }
            recipeData.append(ingredientAndAmount)
            recipeData[0].insert("Ingredients", at: 0)
            recipeData.append(recipe.recipeSteps)
            recipeData[1].insert("Procedure", at: 0)
        }
    }
    
    var recipeData: [[String]] = []
    
    let recipeImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "pizza")
        view.backgroundColor = .purple
        return view
    }()
    
    let headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateView()
    }
    
    func setupViews() {
        if let window = UIApplication.shared.keyWindow {
            headerHeight = window.frame.height / 1.65
        }
        
        tableView?.contentInset = UIEdgeInsets(top: headerHeight!, left: 0, bottom: 0, right: 0)
        
        headerView.frame = CGRect(x: 0, y: -1 * headerHeight!, width: 100, height: headerHeight!)
        tableView?.backgroundColor = .white
        tableView?.addSubview(headerView)
        headerView.addSubview(recipeImageView)
        
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: headerView.topAnchor),
            recipeImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor)
            ])
        
        updateView()
    }
    
    func updateView() {
        let newHeight = headerHeight!
        var getHeaderFrame =  CGRect(x: 0, y: -newHeight, width: (tableView?.frame.width)!, height: newHeight)
        
        if (tableView?.contentOffset.y)! < newHeight {
            getHeaderFrame.origin.y = (tableView?.contentOffset.y)!
            getHeaderFrame.size.height = -1 * (tableView?.contentOffset.y)!
        }
        
        headerView.frame = getHeaderFrame
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return recipeData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = recipeData[section]
        return section.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        
        switch section {
        case 0:
            if row == 0 {
                let ingredientHeaderCell = tableView.dequeueReusableCell(withIdentifier: ingredientHeaderId) as! IngredientHeaderCell
                ingredientHeaderCell.name = recipeData[section][row]
                ingredientHeaderCell.exportButtonTapped = {
                    let recipe = self.recipe!
                    var textToExport = "\(recipe.name) ingredients\n\n"
                    for item in self.recipeData[section] {
                        if !item.contains("Ingredients") {
                            textToExport.append("\(self.getAmountFromCombined(string: item)) \(self.getIngredientFromCombined(string: item))\n")
                        }
                    }
                    let activityVC = UIActivityViewController(activityItems: [textToExport], applicationActivities: nil)
                    activityVC.popoverPresentationController?.sourceView = self.view
                    self.present(activityVC, animated: true, completion: nil)
                }
                ingredientHeaderCell.separatorInset = UIEdgeInsetsMake(0, ingredientHeaderCell.bounds.size.width, 0, 0)
                ingredientHeaderCell.selectionStyle = .none
                return ingredientHeaderCell
            } else {
                let ingredientCell = tableView.dequeueReusableCell(withIdentifier: ingredientCellId, for: indexPath) as! IngredientTableViewCell
                ingredientCell.name = self.getIngredientFromCombined(string: recipeData[section][row])
                ingredientCell.amount = self.getAmountFromCombined(string: recipeData[section][row])
                return ingredientCell
            }
        case 1:
            // TODO: Procedure cell custom heading ?
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: procedureHeaderId) as! ProcedureHeaderCell
                cell.name = recipeData[section][row]
                cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: procedureCellId) as! ProcedureTableViewCell
                cell.number = row
                cell.stepText = recipeData[section][row]
                cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
                return cell
            }
        default:
            assert(false, "TableViewCell mistake")
        }
        
    }
    
    func getIngredientFromCombined(string: String) -> String {
        return string.components(separatedBy: ";")[0].capitalizingFirstLetter()
    }
    
    func getAmountFromCombined(string: String) -> String {
        return string.components(separatedBy: ";")[1]
    }
    
}
