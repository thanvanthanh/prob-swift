//
//  UIStackView.swift
//  Probit
//
//  Created by Thân Văn Thanh on 26/08/2022.
//

import UIKit

extension UIStackView {
    
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
    
    func spacer(color: UIColor = .clear, height: CGFloat = 1) {
        let view = UIView()
        view.backgroundColor = color
        self.addArrangedSubview(view)
    }
}
