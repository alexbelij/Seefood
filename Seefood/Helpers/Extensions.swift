//
//  Extensions.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/10/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension UITextView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

//extension UITextView {
//    func expand(scale: CGFloat) {
//        let transformation = CGAffineTransform(scaleX: scale, y: scale)
//
//        UIView.animate(withDuration: 0.2, animations: {
//            self.transform = transformation
//        })
//    }
//}
//
//extension UIImageView {
//    func expand(scale: CGFloat) {
//        let transformation = CGAffineTransform(scaleX: scale, y: scale)
//
//        UIView.animate(withDuration: 0.2, animations: {
//            self.transform = transformation
//        })
//    }
//}

//extension UIButton {
//    func expand(scale: CGFloat) {
//        let transformation = CGAffineTransform(scaleX: scale, y: scale)
//
//        UIView.animate(withDuration: 0.2, animations: {
//            self.transform = transformation
//        })
//    }
//}

extension UISearchBar {
    
    private func getViewElement<T>(type: T.Type) -> T? {
        
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    func getSearchBarTextField() -> UITextField? {
        
        return getViewElement(type: UITextField.self)
    }
    
    func setTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.textColor = color
        }
    }
    
    func setTextFieldColor(color: UIColor) {
        
        if let textField = getViewElement(type: UITextField.self) {
            switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6
                
            case .prominent, .default:
                textField.backgroundColor = color
            }
        }
    }
    
    func setPlaceholderTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedStringKey.foregroundColor: color])
        }
    }
    
    func setTextFieldClearButtonColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            
            let button = textField.value(forKey: "clearButton") as! UIButton
            if let image = button.imageView?.image {
                button.setImage(image.transform(withNewColor: color), for: .normal)
            }
        }
    }
    
    func setSearchImageColor(color: UIColor) {
        
        if let imageView = getSearchBarTextField()?.leftView as? UIImageView {
            imageView.image = imageView.image?.transform(withNewColor: color)
        }
    }
}

extension UIImage {
    
    func transform(withNewColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage!)
        
        color.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension UIView {
    func expand(scale: CGFloat) {
        let transformation = CGAffineTransform(scaleX: scale, y: scale)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = transformation
        })
    }
}

public extension UIImage {
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    public func withRoundCorners(_ cornerRadius: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: CGPoint.zero, size: size)
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        
        context?.beginPath()
        context?.addPath(path.cgPath)
        context?.closePath()
        context?.clip()
        
        draw(at: CGPoint.zero)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return image;
    }
    
}

// TODO: wtf
extension UICollectionView {
    func scrollToFooter(_ indexPath: IndexPath)  {
//        let indexPath = IndexPath(item: 1, section: section)
//        if let attributes =  self.layoutAttributesForSupplementaryElement(ofKind: UICollectionElementKindSectionFooter, at: indexPath) {
//
//            let topOfHeader = CGPoint(x: 0, y: attributes.frame.origin.y - self.contentInset.top)
//            self.setContentOffset(topOfHeader, animated:true)
//        }
//        if let attributes = self.layoutAttributesForSupplementaryElement(ofKind: UICollectionElementKindSectionFooter, at: indexPath), let cellAttributes = self.layoutAttributesForItem(at: indexPath) {
            //        let lastItemIndex = NSIndexPath(item: FoodData.currentPictures.count - 1, section: 0)
            //        picturesView.scrollToItem(at: lastItemIndex as IndexPath, at: .right, animated: true)
            self.scrollToItem(at: indexPath, at: .right, animated: true)
//            let scrollingPosition = CGPoint(x: attributes.frame.width, y: 0)
//            self.setContentOffset(scrollingPosition, animated: true)
        //}
    }
}
