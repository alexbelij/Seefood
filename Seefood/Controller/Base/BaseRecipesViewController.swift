//
//  BaseRecipesViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/22/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import RxSwift

class BaseRecipesViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        view.backgroundColor = .white
        self.extendedLayoutIncludesOpaqueBars = true
        UIApplication.shared.statusBarStyle = .default
        navigationItem.largeTitleDisplayMode = .never
        if let nav = navigationController?.navigationBar {
            nav.prefersLargeTitles = false
            nav.barTintColor = .white
            nav.isTranslucent = true
            nav.tintColor = Constants.Colors().secondaryColor
        }
        recipesData = calculateRecipes()
        if recipesCollectionViewController.getNumberOfData() > 0 {
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.searchBar.tintColor = Constants.Colors().secondaryColor
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            setupNavBarButtons()
        }
        recipesCollectionViewController.collectionView?.reloadData()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recipesData = calculateRecipes()
        DispatchQueue.main.async {
            self.recipesCollectionViewController.collectionView?.reloadData()
        }
    }
    
    lazy var filterMenu: FilterMenuHandler = {
        let handler = FilterMenuHandler()
        handler.filtersCollectionViewController.filterCellTapped = { (filter) -> () in
            var lastIndex: IndexPath? = nil
            self.filtersCollectionViewController.collectionView?.performBatchUpdates({
                self.activeFilters[0].append(filter)
                self.filtersCollectionViewController.availableFilters = self.activeFilters
                lastIndex = IndexPath(item: self.activeFilters[0].count - 1, section: 0)
                self.filtersCollectionViewController.collectionView?.insertItems(at: [lastIndex!])
            }, completion: { completed in

            })
        }
        return handler
    }()
    
    var filtersContainerInitialHeightConstraint: NSLayoutConstraint?
    var filtersContainerClearedHeightConstraint: NSLayoutConstraint?
    
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let filtersContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        return view
    }()
    
    lazy var filtersCollectionViewController: FiltersCollectionViewController = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let vc = FiltersCollectionViewController(collectionViewLayout: layout)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.notOnlyAvailableFilters = false
        vc.availableFilterHeaders = activeFilterHeaders
        vc.availableFilters = activeFilters
        vc.collectionView?.alwaysBounceHorizontal = true
        vc.collectionView?.alwaysBounceVertical = false
        vc.collectionView?.showsHorizontalScrollIndicator = false
        vc.collectionView?.backgroundColor = .clear
        return vc
    }()
    
    let recipesContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var recipesCollectionViewController: RecipesCollectionViewController = {
        let layout = UICollectionViewFlowLayout()
        let vc = RecipesCollectionViewController(collectionViewLayout: layout)
        vc.recipesData = self.recipesData
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        return vc
    }()
    
    func setupNavBarButtons() {
        let button = UIButton()
        button.clipsToBounds = false
        button.backgroundColor = .clear
        button.setTitleColor(Constants.Colors().secondaryColor, for: .normal)
        button.setTitle("Filter", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext", size: 10)
        button.layer.borderColor = Constants.Colors().secondaryColor.cgColor
        button.addTarget(self, action: #selector(filterButtonTouchUpInside), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.setRightBarButton(barButtonItem, animated: true)
    }
    
    func setupViews() {
        view.addSubview(recipesContainer)
        addChildViewController(recipesCollectionViewController)
        recipesContainer.addSubview(recipesCollectionViewController.view)
        recipesCollectionViewController.didMove(toParentViewController: self)
        
        view.addSubview(filtersContainer)
        filtersContainer.addSubview(blurView)
        addChildViewController(filtersCollectionViewController)
        filtersContainer.addSubview(filtersCollectionViewController.view)
        filtersCollectionViewController.didMove(toParentViewController: self)
        
        filtersContainerInitialHeightConstraint = filtersContainer.heightAnchor.constraint(equalToConstant: 50)
        filtersContainerClearedHeightConstraint = filtersContainer.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            filtersContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filtersContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filtersContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filtersContainerInitialHeightConstraint!,
            
            blurView.topAnchor.constraint(equalTo: filtersContainer.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: filtersContainer.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: filtersContainer.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: filtersContainer.bottomAnchor),
            
            recipesContainer.topAnchor.constraint(equalTo: view.topAnchor),
            recipesContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipesContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recipesContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "|-0-[v0]-0-|", options: [], metrics: nil, views: ["v0": recipesCollectionViewController.view]) +
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: [], metrics: nil, views: ["v0": recipesCollectionViewController.view]) +
            NSLayoutConstraint.constraints(withVisualFormat: "|-0-[v0]-0-|", options: [], metrics: nil, views: ["v0": filtersCollectionViewController.view]) +
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: [], metrics: nil, views: ["v0": filtersCollectionViewController.view]))
    }
    
    let disposeBag = DisposeBag()
    
    // MARK: Should be overriden in child classes
    func calculateRecipes() -> [Recipe] {
        return [Recipe]()
    }
    var recipesData = [Recipe]()
    fileprivate var filtering = false
    fileprivate var filteredRecipes = [Recipe]()
    
    fileprivate var activeFilterHeaders = ["Active"]
    fileprivate var activeFilters: [[String]] = [["asdf"]]
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            self.filteredRecipes = self.recipesData.filter({ (recipe) -> Bool in
                if activeFilters.count > 0 {
                    for filter in activeFilters[0] {
                        if recipe.tags.contains(filter) {
                            return recipe.name.lowercased().contains(text.lowercased())
                        }
                    }
                    return false
                } else {
                    return recipe.name.lowercased().contains(text.lowercased())
                }
            })
            self.recipesCollectionViewController.recipesData = filteredRecipes
            self.filtering = true
        }
        else {
            self.filtering = false
            self.recipesCollectionViewController.recipesData = calculateRecipes()
            self.filteredRecipes.removeAll()
        }
        self.recipesCollectionViewController.collectionView?.reloadData()
    }
    
    @objc func filterButtonTouchUpInside() {
        filterMenu.showFilterMenu()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationItem.searchController?.searchBar.endEditing(true)
    }
    
}


