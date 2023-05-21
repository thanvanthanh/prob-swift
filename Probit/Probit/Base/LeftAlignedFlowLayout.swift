//
//  File.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 04/10/2565 BE.
//

import Foundation
import UIKit


class LeftAlignedFlowLayout: UICollectionViewFlowLayout {
    
    override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return AppConstant.isLanguageRightToLeft
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let originalAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        var leftMargin: CGFloat = 0.0
        var lastY: Int = 0
        return originalAttributes.map {
            let changedAttribute = $0
            // Check if start of a new row.
            // Center Y should be equal for all items on the same row
            if Int(changedAttribute.center.y.rounded()) != lastY {
                leftMargin = sectionInset.left
            }
            changedAttribute.frame.origin.x = leftMargin
            lastY = Int(changedAttribute.center.y.rounded())
            leftMargin += changedAttribute.frame.width + minimumInteritemSpacing
            return changedAttribute
        }
    }
}
