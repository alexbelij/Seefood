//
//  CameraViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/7/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import SwiftyCam

class CameraViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraDelegate = self
        captureButton.delegate = self
        audioEnabled = false
        setupViews()
        presentElements(duration: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if FoodData.fromPopped {
            FoodData.currentPictures.removeAll()
            self.picturesHandler.picturesView.reloadData()
            FoodData.fromPopped = false
        }
        presentElements(duration: 0.3)
        picturesHandler.presentPictures()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        picturesHandler.disappearPictures()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var onTakePicture: (()->())?
    
    let captureButton: SwiftyCamButton = {
        let button = SwiftyCamButton()
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 5
        button.layer.cornerRadius = 35
        button.clipsToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.Colors().secondaryColor
        if let image = UIImage(named: "ic_check_white") {
            button.setImage(image, for: .normal)
        }
        
        button.layer.cornerRadius = 25
        button.clipsToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.expand(scale: 0.001)

        button.layer.shadowRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        button.layer.shadowOpacity = 0.75
        
        return button
    }()
    
    lazy var picturesHandler: PicturesHandler = {
        let handler = PicturesHandler()
        handler.cellDeleted = {
            self.checkButton.expand(scale: FoodData.currentPictures.count < 1 ? 0.001 : 1)
        }
        handler.picturesDismissed = {
            self.navigationController?.pushViewController(LoadingViewController(), animated: true)
        }
        return handler
    }()
    
    var captureButtonInitialBottomConstraint: NSLayoutConstraint?
    var captureButtonDismissedBottomConstraint: NSLayoutConstraint?
    
    func setupViews() {
        view.addSubview(captureButton)
        view.addSubview(checkButton)
        
        let viewSafeMargins = view.safeAreaLayoutGuide
        
        captureButtonInitialBottomConstraint = captureButton.bottomAnchor.constraint(equalTo: viewSafeMargins.bottomAnchor, constant: -20)
        captureButtonDismissedBottomConstraint = captureButton.topAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            captureButtonInitialBottomConstraint!,
            captureButton.centerXAnchor.constraint(equalTo: viewSafeMargins.centerXAnchor),
            captureButton.widthAnchor.constraint(equalToConstant: 70),
            captureButton.heightAnchor.constraint(equalToConstant: 70),
            
            checkButton.trailingAnchor.constraint(equalTo: viewSafeMargins.trailingAnchor, constant: -20),
            checkButton.bottomAnchor.constraint(equalTo: viewSafeMargins.bottomAnchor, constant: -30),
            checkButton.widthAnchor.constraint(equalToConstant: 50),
            checkButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
    }
    
    @objc func checkButtonTapped() {
        picturesHandler.dismissPictures()
        clearViewForLoading()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        picturesHandler.addPicture(picture: photo)
        checkButton.expand(scale: 1)
    }
    
    func clearViewForLoading() {
        clearCaptureButton(clear: true)
        clearCheckButton(clear: true)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.captureButton.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { completed in
            self.captureButton.isHidden = true
            self.checkButton.isHidden = true
        })
    }
    
    func presentElements(duration: Double) {
        clearCaptureButton(clear: false)
        clearCheckButton(clear: !(FoodData.currentPictures.count > 0))
        self.captureButton.isHidden = false
        self.checkButton.isHidden = false
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.captureButton.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func clearCaptureButton(clear: Bool) {
        captureButtonInitialBottomConstraint?.isActive = !clear
        captureButtonDismissedBottomConstraint?.isActive = clear
    }
    
    func clearCheckButton(clear: Bool) {
        checkButton.expand(scale: clear ? 0.001 : 1)
    }
    
}

