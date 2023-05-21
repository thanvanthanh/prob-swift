//
//  PurchaseInfoInputCell.swift
//  Probit
//
//  Created by Bradley Hoang on 28/09/2022.
//

import UIKit

final class PurchaseInfoInputCell: BaseCollectionViewCell {
    
    struct Configuration {
        static let horizontalPadding: CGFloat = 13
        static let imageViewWidth: CGFloat = 14
        static let spacing: CGFloat = 4
        static var totalOffset: CGFloat {
            return imageViewWidth + spacing + horizontalPadding * 2
        }
    }
    
    
    // MARK: - IBOutlet
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var selectedImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
}

// MARK: - Public
extension PurchaseInfoInputCell {
    func setupCell(object: Any, isSelected: Bool = false) {
        if let data = object as? String {
            titleLabel.text = data
            updateUI(with: isSelected)
        }
    }
}

// MARK: - Private
private extension PurchaseInfoInputCell {
    func updateUI(with isSelected: Bool) {
        selectedImageView.isHidden = !isSelected
        containerView.backgroundColor = isSelected ? UIColor.color_4231c8_6f6ff7 : UIColor.color_f5f5f5_646464
        titleLabel.textColor = isSelected ? UIColor(hexString: "FAFAFA") : UIColor.color_646464_fafafa
    }
}
