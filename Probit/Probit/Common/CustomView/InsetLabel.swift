//
//  InsetLabel.swift
//  Probit
//
//  Created by Dang Nguyen on 21/11/2022.
//

import UIKit

class InsetLabel: UILabel {
    override func draw(_ rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
            super.drawText(in: rect.inset(by: insets))
       }
}
