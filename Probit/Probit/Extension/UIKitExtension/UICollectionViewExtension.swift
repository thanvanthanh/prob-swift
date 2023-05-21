//
//  UICollectionViewExtension.swift
//  Probit
//
//  Created by Nguyen Quang on 24/08/2022.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: className)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T? {
        return self.dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as? T
    }
    
    func reloadData(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 1, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
}
