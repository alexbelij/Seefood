//
//  FilterMenuHandler.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/27/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FilterMenuHandler: PopupController {

    let filterCategories = ["Diet", "Another"]
    let filters = [["Vegan", "Vegetarian", "Non-Veg"], ["asdf", "4312"]]
    let currentFilters = [String]()
    
    lazy var filtersCollectionViewController: FiltersCollectionViewController = {
        let layout = UICollectionViewFlowLayout()
        let vc = FiltersCollectionViewController(collectionViewLayout: layout)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.availableFilterHeaders = filterCategories
        vc.availableFilters = filters
        vc.collectionView?.showsVerticalScrollIndicator = false
        return vc
    }()
    
    override func setupViews() {
        super.setupViews()
        
        baseView.addSubview(filtersCollectionViewController.view)
        setupContent(content: filtersCollectionViewController.view)
        
        darkView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doneButtonTouchUpInside)))
        darkView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))))
    }
    
}

class FiltersCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        
        // TODO: Add filter section headers
        
        collectionView?.register(FilterHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader.self, withReuseIdentifier: filterSectionHeaderId)
        collectionView?.register(FilterCell.self, forCellWithReuseIdentifier: filterCellId)
    }

    let filterSectionHeaderId = "filterSectionHeaderId"
    let filterCellId = "filterCellId"
    var availableFilterHeaders = [String]()
    var availableFilters = [[String]]()
    var notOnlyAvailableFilters = true
    
    var filterCellTapped: ((_ cell: FilterCell)->())?
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if notOnlyAvailableFilters {
            return availableFilterHeaders.count
        } else {
            return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if notOnlyAvailableFilters {
            return availableFilters[section].count
        } else {
            return availableFilters[0].count
        }
    }
    
    // MARK: Filter cell setup
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterCellId, for: indexPath) as! FilterCell
        cell.name = availableFilters[indexPath.section][indexPath.row]
        cell.filterSelected = !notOnlyAvailableFilters
        cell.cellTapped = {
            if self.notOnlyAvailableFilters {
                self.filterCellTapped?(cell)
            } else {
                if let currentIndexPath = collectionView.indexPath(for: cell) {
                    self.availableFilters[0].remove(at: currentIndexPath.row)
                    collectionView.performBatchUpdates({
                        collectionView.deleteItems(at: [currentIndexPath])
                    }, completion: nil)
                }
                self.filterCellTapped?(cell)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = availableFilters[indexPath.section][indexPath.row]
        let font = UIFont(name: "AvenirNext-Demibold", size: 30)
        let fontAttributes: [NSAttributedStringKey: UIFont] = [NSAttributedStringKey.font: font!]
        var baseSize = (text as NSString).size(withAttributes: fontAttributes)
        baseSize.height = 50
        return baseSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    // MARK: Header and Footer setup
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: filterSectionHeaderId, for: indexPath) as! FilterHeaderCell
            header.name = availableFilterHeaders[indexPath.section]
            return header
        default:
            assert(false, "Not a Header or Footer")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if notOnlyAvailableFilters {
            return CGSize(width: collectionView.frame.width, height: 40)
        } else {
            return CGSize.zero
        }
    }
}

class FilterCell: BaseCollectionViewCell {
    
    var name: String? {
        didSet {
            filterName.setTitle(name, for: .normal)
        }
    }
    
    var filterSelected: Bool? {
        didSet {
            if filterSelected! {
                filterName.backgroundColor = Constants.Colors().secondaryColor
                filterName.setTitleColor(.white, for: .normal)
            } else {
                filterName.backgroundColor = Constants.Colors().primaryColor
                filterName.setTitleColor(.black, for: .normal)
            }
        }
    }

    var cellTapped: (()->())?
    
    let filterName: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.Colors().primaryColor
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Demibold", size: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment = .center
        button.clipsToBounds = true
        button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        button.layer.cornerRadius = 20
        button.sizeToFit()
        return button
    }()
    
    let disposeBag = DisposeBag()
    
    override func setupViews() {
        
        filterName.rx.tap.bind {
            self.cellTapped?()
        }.disposed(by: disposeBag)
        
        self.addSubview(filterName)
        
        NSLayoutConstraint.activate([
            filterName.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            filterName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            filterName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
            filterName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            ])
    }
    
}

class FilterHeaderCell: BaseCollectionViewCell {
    
    var name: String? {
        didSet {
            filterHeaderName.text = name
        }
    }
    
    let filterHeaderName: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Colors().secondaryColor
        label.font = UIFont(name: "AvenirNext-Demibold", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupViews() {
        self.addSubview(filterHeaderName)
        
        NSLayoutConstraint.activate([
            filterHeaderName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            filterHeaderName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            filterHeaderName.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    
}

