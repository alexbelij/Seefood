//
//  IngredientsViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/10/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class IngredientsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        if let nav = navigationController?.navigationBar {
            nav.prefersLargeTitles = true
            nav.barTintColor = .white
            nav.tintColor = Constants.Colors().secondaryColor
            nav.isTranslucent = true
            self.title = "Ingredients"
        }
        FoodData.fromPopped = true
        setupNavBarButtons()
        setupViews()
        ingredientsCollectionView.reloadData()
    }
    
    func setupViews() {
        view.addSubview(ingredientsCollectionView)
        view.addSubview(viewRecipesButton)
        viewRecipesButton.addSubview(viewRecipesArrow)
        
        let safeViewMargins = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            viewRecipesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewRecipesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewRecipesButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -49),
            viewRecipesButton.heightAnchor.constraint(equalToConstant: 50),
            
            viewRecipesArrow.topAnchor.constraint(equalTo: viewRecipesButton.topAnchor, constant: 5),
            viewRecipesArrow.bottomAnchor.constraint(equalTo: viewRecipesButton.bottomAnchor, constant: -5),
            viewRecipesArrow.trailingAnchor.constraint(equalTo: viewRecipesButton.trailingAnchor),
            viewRecipesArrow.widthAnchor.constraint(equalToConstant: 40),
            
            ingredientsCollectionView.topAnchor.constraint(equalTo: safeViewMargins.topAnchor),
            ingredientsCollectionView.leadingAnchor.constraint(equalTo: safeViewMargins.leadingAnchor),
            ingredientsCollectionView.trailingAnchor.constraint(equalTo: safeViewMargins.trailingAnchor),
            ingredientsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        
        viewRecipesButton.addTarget(self, action: #selector(viewRecipesButtonTapped), for: .touchUpInside)
        viewRecipesButton.addTarget(self, action: #selector(viewRecipesButtonTouchDown), for: .touchDown)
        viewRecipesButton.addTarget(self, action: #selector(viewRecipeButtonTouchUp), for: .touchUpInside)
        viewRecipesButton.addTarget(self, action: #selector(viewRecipeButtonTouchUp), for: .touchUpOutside)
    }
    
    func setupNavBarButtons() {
        self.navigationItem.hidesBackButton = true
        let closeButtonImage = UIImage(named: "ic_close_white")?.withRenderingMode(.alwaysTemplate)
        let closeButton = UIButton()
        closeButton.contentMode = .scaleAspectFill
        closeButton.setImage(closeButtonImage, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTouchUpInside(sender:)), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let searchBarButtonItem = UIBarButtonItem(customView: closeButton)
        navigationItem.setLeftBarButton(searchBarButtonItem, animated: true)
    }
    
    lazy var ingredientsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.register(IngredientCell.self, forCellWithReuseIdentifier: cellId)
        view.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        view.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId)
        view.backgroundColor = .white
        view.alwaysBounceVertical = true
        return view
    }()
    
    let headerId = "headerId"
    let cellId = "cellId"
    let footerId = "footerId"
    
    let viewRecipesArrow: UIImageView = {
        let image = UIImage(named: "ic_keyboard_arrow_right_white-1")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let viewRecipesButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.Colors().secondaryColor
        button.setTitleColor(.white, for: .normal)
        button.setTitle("SEE RECIPES", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 25)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func closeButtonTouchUpInside(sender: UIButton) {        
        let stackedControllers = self.navigationController?.viewControllers
        for controller in stackedControllers! {
            if controller.isKind(of: CameraViewController.self) {
                self.navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
    
    @objc func viewRecipesButtonTapped() {
        self.navigationController?.pushViewController(CalculatedRecipesViewController(), animated: true)
    }
    
    @objc func viewRecipesButtonTouchDown() {
        UIView.transition(with: viewRecipesButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.viewRecipesButton.backgroundColor = Constants.Colors().secondaryDarkColor
        }, completion: nil)
    }
    
    @objc func viewRecipeButtonTouchUp() {
        UIView.transition(with: viewRecipesButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.viewRecipesButton.backgroundColor = Constants.Colors().secondaryColor
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FoodData.currentPictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ingredientsCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! IngredientCell
        let ingredient = FoodData.currentPictures[indexPath.row]
        cell.picture = ingredient.image
        cell.name = ingredient.name
        cell.ingredientLabelChanged = { text in
            FoodData.currentPictures[indexPath.row].name = text
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ingredientsCollectionView.frame.width / 2
        return CGSize(width: width, height: width * 1.78)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
            return header
        case UICollectionElementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
            return footer
        default:
            assert(false, "Not Header or Footer")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = ingredientsCollectionView.frame.width / 2
        return CGSize(width: width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = ingredientsCollectionView.frame.width / 2
        return CGSize(width: width, height: 70)
    }
    
}
