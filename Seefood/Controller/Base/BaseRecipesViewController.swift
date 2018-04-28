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
    
    override func viewWillAppear(_ animated: Bool) {
        if activeFilters[0].count > 0 {
            self.navigationController?.navigationBar.shouldRemoveShadow(true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recipesData = calculateRecipes()
        DispatchQueue.main.async {
            self.recipesCollectionViewController.collectionView?.reloadData()
        }
    }
    
    lazy var filterMenu: FilterMenuHandler = {
        let handler = FilterMenuHandler(heightRatio: 0.5, title: "Add Filters")
        handler.filtersCollectionViewController.filterCellTapped = { (cell) -> () in
            var lastIndex: IndexPath? = nil
            let filtersWereEmpty = self.activeFilters[0].count == 0
            if !self.activeFilters[0].contains(cell.name!) {
                cell.filterSelected = true
                self.filtersCollectionViewController.collectionView?.performBatchUpdates({
                    self.activeFilters[0].append(cell.name!)
                    self.filtersCollectionViewController.availableFilters = self.activeFilters
                    lastIndex = IndexPath(item: self.activeFilters[0].count - 1, section: 0)
                    self.filtersCollectionViewController.collectionView?.insertItems(at: [lastIndex!])
                })
                if filtersWereEmpty {
                    self.showFilterMenu(show: true)
                    self.navigationController?.navigationBar.shouldRemoveShadow(true)
                }
                self.updateFilterResults()
                self.filtersCollectionViewController.collectionView?.reloadItems(at: [lastIndex!])
            } else {
                if let currentIndexPath = self.filtersCollectionViewController.collectionView?.indexPath(for: cell) {
                    self.filtersCollectionViewController.collectionView?.performBatchUpdates({
                        self.filtersCollectionViewController.collectionView?.deleteItems(at: [currentIndexPath])
                    }, completion: nil)
                }
                cell.filterSelected = false
                for i in 0 ..< self.activeFilters[0].count {
                    if self.activeFilters[0][i] == cell.name {
                        self.activeFilters[0].remove(at: i)
                        break
                    }
                }
                self.updateFilterResults()
                self.filtersCollectionViewController.availableFilters = self.activeFilters
                self.filtersCollectionViewController.collectionView?.reloadData()
                if self.activeFilters[0].count == 0 {
                    self.showFilterMenu(show: false)
                }
            }
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
    
    let filtersBottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
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
        vc.filterCellTapped = { (cell) -> () in
            let allFilterCells = self.filterMenu.filtersCollectionViewController.collectionView?.visibleCells
            for visibleCell in allFilterCells! {
                if let visibleFilterCell = visibleCell as? FilterCell {
                    if cell.name! == visibleFilterCell.name! {
                        visibleFilterCell.filterSelected = false
                    }
                }
            }
            for i in 0 ..< self.activeFilters[0].count {
                if self.activeFilters[0][i] == cell.name {
                    self.activeFilters[0].remove(at: i)
                    break
                }
            }
            self.updateFilterResults()
            if self.activeFilters[0].count == 0 {
                self.showFilterMenu(show: false)
            }
        }
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
        filtersContainer.addSubview(filtersBottomBorder)
        addChildViewController(filtersCollectionViewController)
        filtersContainer.addSubview(filtersCollectionViewController.view)
        filtersCollectionViewController.didMove(toParentViewController: self)
        
        filtersContainerInitialHeightConstraint = filtersContainer.heightAnchor.constraint(equalToConstant: 50)
        filtersContainerClearedHeightConstraint = filtersContainer.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            filtersContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filtersContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filtersContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filtersContainerClearedHeightConstraint!,
            
            blurView.topAnchor.constraint(equalTo: filtersContainer.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: filtersContainer.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: filtersContainer.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: filtersContainer.bottomAnchor),
            
            filtersBottomBorder.leadingAnchor.constraint(equalTo: filtersContainer.leadingAnchor),
            filtersBottomBorder.trailingAnchor.constraint(equalTo: filtersContainer.trailingAnchor),
            filtersBottomBorder.bottomAnchor.constraint(equalTo: filtersContainer.bottomAnchor),
            filtersBottomBorder.heightAnchor.constraint(equalToConstant: 0.5),
            
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
    fileprivate var filteredRecipes = [Recipe]()
    
    fileprivate var activeFilterHeaders = ["Active"]
    fileprivate var activeFilters: [[String]] = [[]]
    
    func updateFilterResults() {
        // Filter by searchbar text
        let searchController = self.navigationItem.searchController
        if let text = searchController?.searchBar.text, !text.isEmpty {
            self.filteredRecipes = self.recipesData.filter({ (recipe) -> Bool in
                return recipe.name.lowercased().contains(text.lowercased())
            })
        } else {
            self.filteredRecipes = self.recipesData
        }
        // Filter by selected filters
        if activeFilters[0].count > 0 {
            self.filteredRecipes = self.recipesData.filter({ (recipe) -> Bool in
                for filter in activeFilters[0] {
                    if !recipe.tags.contains(filter) {
                        return false
                    }
                }
                return true
            })
        }
        self.recipesCollectionViewController.recipesData = filteredRecipes
        self.recipesCollectionViewController.collectionView?.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        updateFilterResults()
    }
    
    @objc func filterButtonTouchUpInside() {
        self.navigationItem.searchController?.searchBar.resignFirstResponder()
        filterMenu.showPopupMenu()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationItem.searchController?.searchBar.endEditing(true)
    }
    
    func showFilterMenu(show: Bool) {
        filtersContainerInitialHeightConstraint?.isActive = show
        filtersContainerClearedHeightConstraint?.isActive = !show
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.recipesCollectionViewController.collectionView?.contentInset = UIEdgeInsets(top: show ? 50 : 0, left: 0, bottom: 0, right: 0)
        }, completion: { completed in
            if (self.filtersContainerClearedHeightConstraint?.isActive)! {
                self.navigationController?.navigationBar.shouldRemoveShadow(false)
            }
        })
    }
    
}


