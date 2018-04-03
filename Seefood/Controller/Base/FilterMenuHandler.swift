//
//  FilterMenuHandler.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/27/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class FilterMenuHandler: NSObject {
    
    override init() {
        super.init()
        setupViews()
    }
    
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
        return view
    }()
    
    let headerView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let headerTitle: UILabel = {
        let label = UILabel()
        label.text = "Filter"
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
        headerView.contentView.addSubview(doneButton)
        
        baseView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height / 2)
        
        NSLayoutConstraint.activate([
            darkView.topAnchor.constraint(equalTo: window.topAnchor),
            darkView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            darkView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            darkView.bottomAnchor.constraint(equalTo: window.bottomAnchor),
            
            filtersCollectionViewController.view.topAnchor.constraint(equalTo: baseView.topAnchor),
            filtersCollectionViewController.view.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            filtersCollectionViewController.view.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
            filtersCollectionViewController.view.bottomAnchor.constraint(equalTo: baseView.bottomAnchor),
            
            headerView.topAnchor.constraint(equalTo: baseView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 45),
            
            headerTitle.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerTitle.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            headerTitle.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            
            doneButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            doneButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            doneButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 90)
            ])
        
        darkView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doneButtonTouchUpInside)))
        darkView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))))
        doneButton.addTarget(self, action: #selector(doneButtonTouchUpInside), for: .touchUpInside)
    }
    
    func showFilterMenu() {
        baseView.isHidden = false
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.darkView.alpha = 0.5
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
        let menuMaxY = baseView.frame.maxY
        let menuMinY = baseView.frame.minY
        let menuHeight = baseView.frame.height
        
        if menuMinY + translation.y >= menuHeight {
            baseView.center = CGPoint(x: baseView.center.x, y: baseView.center.y + translation.y)
            darkView.alpha = menuHeight / menuMaxY
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

class FiltersCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        
    }
    
    
    
}

