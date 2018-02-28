//
//  PicturesHandler.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/7/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class PicturesHandler: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    override init() {
        super.init()
        picturesView.delegate = self
        picturesView.dataSource = self
        picturesView.register(PreviewPictureCell.self, forCellWithReuseIdentifier: cellId)
        picturesView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId)
        picturesView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        setupViews()
    }

    let cellId = "cellId"
    let footerId = "footerId"
    let headerId = "headerId"
    let collectionHeight: CGFloat = 125
    var cellDeleted: (()->())?
    var picturesDismissed: (()->())?
    
    lazy var picturesView: UICollectionView = {
        let layout = CustomFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        //collectionView.bounces = false
        collectionView.bouncesZoom = false
        return collectionView
    }()
    
    func setupViews() {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(picturesView)
            picturesView.frame = CGRect(x: 0, y: window.frame.height - 270, width: window.frame.width, height: collectionHeight)
        }
    }
    
    func addPicture(picture: UIImage) {
        var lastIndex: IndexPath? = nil
        picturesView.performBatchUpdates({
            FoodData.currentPictures.append((picture, ""))
            lastIndex = IndexPath(item: FoodData.currentPictures.count - 1, section: 0)
            self.picturesView.insertItems(at: [lastIndex!])
        }, completion: { completed in
            self.picturesView.scrollToFooter(lastIndex!)
        })
    }
    
    func showPictures() {
        picturesView.isHidden = false
    }
    
    func disappearPictures() {
        picturesView.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FoodData.currentPictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PreviewPictureCell
        let imagePair = FoodData.currentPictures[indexPath.row]
        cell.picture = imagePair.image
        cell.deletePressed = {
            if let currentIndexPath = self.picturesView.indexPath(for: cell) {
                FoodData.currentPictures.remove(at: currentIndexPath.row)
                self.picturesView.performBatchUpdates({
                    self.picturesView.deleteItems(at: [currentIndexPath])
                    self.cellDeleted?()
                }, completion: nil)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = collectionHeight * 0.85
        return CGSize(width: cellHeight * 0.67, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let cellHeight = collectionHeight
        return CGSize(width: 10, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let cellHeight = collectionHeight
        return CGSize(width: 10, height: cellHeight)
    }
    
    func dismissPictures() {
        if let window = UIApplication.shared.keyWindow {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.picturesView.frame.origin.x = 0 - window.frame.maxX
                self.picturesView.alpha = 0
            }, completion: {completed in
                self.picturesView.isHidden = true
                self.picturesDismissed?()
            })
        }
    }
    
    func presentPictures() {
        self.picturesView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.picturesView.frame.origin.x = 0
            self.picturesView.alpha = 1
        }, completion: nil)
        
    }
    
}
