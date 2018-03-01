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
    
    override func viewDidLoad() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(RecipeCell.self, forCellWithReuseIdentifier: recipeCellId)
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId)
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = false
        setupViews()
    }
    
    func setupViews() {
        collectionView?.backgroundView = noResults
        NSLayoutConstraint.activate([
            noResults.topAnchor.constraint(equalTo: view.topAnchor),
            noResults.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            noResults.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noResults.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    
    var recipesData = [Recipe]()
    let recipeCellId = "recipeCellId"
    let footerId = "footerId"
    var isBookmarkController = false
    var cellDeleted: (()->())?
    
    let noResults: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textAlignment = .center
        label.text = "No Results"
        return label
    }()
    
    func getNumberOfData() -> Int {
        return recipesData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundView?.isHidden = recipesData.count > 0
        return recipesData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recipeCellId, for: indexPath) as! RecipeCell
        
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
                    if self.isBookmarkController {
                        guard let currentIndexPath = self.collectionView?.indexPath(for: cell) else {
                            assert(false, "indexPath error")
                        }
                        self.recipesData.remove(at: currentIndexPath.row)
                        self.collectionView?.performBatchUpdates({
                            self.collectionView?.deleteItems(at: [currentIndexPath])
                        }, completion: nil)
                        self.cellDeleted?()
                    }
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
        return CGSize(width: width, height: width * 0.64)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
            return footer
        default:
            assert(false, "Not Header or Footer")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 20)
    }
    
}
