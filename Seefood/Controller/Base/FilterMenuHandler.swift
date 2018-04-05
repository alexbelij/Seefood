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

class FilterMenuHandler: NSObject {
    
    override init() {
        super.init()
        setupViews()
        setupRx()
    }

    let filterCategories = ["Diet", "Another"]
    let filters = [["Vegan", "Vegetarian", "Non-Veg"], ["asdf", "4312"]]
    let currentFilters = [String]()
    
    let darkView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let baseView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .white
        return view
    }()
    
    let headerView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let headerBottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let headerTitle: UILabel = {
        let label = UILabel()
        label.text = "Add Filters"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.clipsToBounds = false
        button.backgroundColor = .clear
        button.setTitleColor(Constants.Colors().secondaryColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "AvenirNext", size: 10)
        return button
    }()
    
    lazy var filtersCollectionViewController: FiltersCollectionViewController = {
        let layout = UICollectionViewFlowLayout()
        let vc = FiltersCollectionViewController(collectionViewLayout: layout)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.availableFilterHeaders = filterCategories
        vc.availableFilters = filters
        return vc
    }()
    
    func setupViews() {
        
        
        guard let window = UIApplication.shared.keyWindow else {
            assert(false, "Window missing")
        }
        
        window.addSubview(darkView)
        window.addSubview(baseView)
        baseView.addSubview(filtersCollectionViewController.view)
        baseView.addSubview(headerView)
        headerView.contentView.addSubview(headerTitle)
        headerView.contentView.addSubview(headerBottomBorder)
        headerView.contentView.addSubview(doneButton)
        
        baseView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height / 2)
        
        NSLayoutConstraint.activate([
            darkView.topAnchor.constraint(equalTo: window.topAnchor),
            darkView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            darkView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            darkView.bottomAnchor.constraint(equalTo: window.bottomAnchor),
            
            filtersCollectionViewController.view.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            filtersCollectionViewController.view.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 14),
            filtersCollectionViewController.view.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -14),
            filtersCollectionViewController.view.bottomAnchor.constraint(equalTo: baseView.bottomAnchor),
            
            headerView.topAnchor.constraint(equalTo: baseView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 44),
            
            headerBottomBorder.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerBottomBorder.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            headerBottomBorder.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            headerBottomBorder.heightAnchor.constraint(equalToConstant: 0.5),
            
            headerTitle.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerTitle.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            headerTitle.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            
            doneButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            doneButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            doneButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 80)
            ])
        
        darkView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doneButtonTouchUpInside)))
        darkView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))))
        
    }
    
    let disposeBag = DisposeBag()
    
    func setupRx() {
        doneButton.rx.tap.bind {
            self.doneButtonTouchUpInside()
        }.disposed(by: disposeBag)
    }
    
    func showFilterMenu() {
        baseView.isHidden = false
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.darkView.alpha = 1
            self.baseView.frame.origin.y = self.baseView.frame.height
        })
    }
    
    func dismissFilterMenu() {
        guard let window = UIApplication.shared.keyWindow else {
            assert(false, "window missing")
        }
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.darkView.alpha = 0
            self.baseView.frame.origin.y = window.frame.height
        }, completion: { completed in
            self.baseView.isHidden = true
        })
    }
    
    @objc func doneButtonTouchUpInside() {
        dismissFilterMenu()
    }
    
    @objc func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        guard let window = UIApplication.shared.keyWindow else {
            assert(false, "window missing")
        }
        let translation = panGesture.translation(in: baseView)
        panGesture.setTranslation(CGPoint.zero, in: baseView)
        let menuMinY = baseView.frame.minY
        let menuHeight = baseView.frame.height
        
        if menuMinY + translation.y >= menuHeight {
            baseView.center = CGPoint(x: baseView.center.x, y: baseView.center.y + translation.y)
            darkView.alpha = (window.frame.height - menuMinY) / menuHeight
        }
        
        if panGesture.state == .ended {
            let locationMargin = menuMinY / window.frame.height
            let duration = Double(locationMargin * 0.2)
            let pastMenuMargin = locationMargin >= 0.7
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.darkView.alpha = pastMenuMargin ? 0 : 1
                self.baseView.frame.origin = CGPoint(x: 0, y: pastMenuMargin ? window.frame.height : self.baseView.frame.height)
            })
        }
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
    
    var filterCellTapped: ((_ filter: String)->())?
    
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
    
    // TODO: Check rx setup
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterCellId, for: indexPath) as! FilterCell
        cell.name = availableFilters[indexPath.section][indexPath.row]
        cell.cellTapped = {
            if self.notOnlyAvailableFilters {
                self.filterCellTapped?(cell.name!)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = availableFilters[indexPath.section][indexPath.row]
        let font = UIFont(name: "AvenirNext-Demibold", size: 30)
        let fontAttributes = [NSAttributedStringKey.font: font]
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

