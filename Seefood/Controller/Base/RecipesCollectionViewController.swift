//
//  RecipesCollectionViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/22/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import CoreData

class RecipesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    override func viewDidLoad() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(RecipeCell.self, forCellWithReuseIdentifier: recipeCellId)
        collectionView?.backgroundColor = .white
    }
    
    var recipesData = [Recipe]()
    let recipeCellId = "recipeCellId"
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipesData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recipeCellId, for: indexPath) as! RecipeCell
        
        // TODO: check
        cell.recipe = recipesData[indexPath.row]
        cell.handleRecipeTap = {
            let recipeViewController = RecipeViewController()
            recipeViewController.title = cell.recipe?.name
            recipeViewController.recipeTableViewController.recipe = cell.recipe
            self.navigationController?.pushViewController(recipeViewController, animated: true)
        }
        cell.handleBookmarkTap = {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<SavedRecipes> = SavedRecipes.fetchRequest()
            let savedRecipes = try context.fetch(fetchRequest)
            
            var found = false
            for savedRecipe in savedRecipes {
                let aRecipe = savedRecipe.recipe as! Recipe
                found = (cell.recipe?.isEqual(aRecipe))!
                if found {
                    context.delete(savedRecipe)
                    cell.bookmarkButton.setImage(UIImage(named: "ic_bookmark_border_white"), for: .normal)
                    break
                }
            }
            
            if !found {
                let entity = NSEntityDescription.entity(forEntityName: "SavedRecipes", in: context)
                let newSavedRecipe = NSManagedObject(entity: entity!, insertInto: context)
                newSavedRecipe.setValue(cell.recipe, forKey: "recipe")
                do {
                    try context.save()
                    cell.bookmarkButton.setImage(UIImage(named: "ic_bookmark_white"), for: .normal)
                } catch {
                    print("Save failed")
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: width * 0.56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
