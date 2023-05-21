//
//  ContractAdressView.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 28/11/2565 BE.
//

import UIKit

class ContractAdressView: BaseView {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var btnNext: StyleButton!
    @IBOutlet weak var stackDescription: UIStackView!
    func show(title: String,
              address: String,
              titleButton: String,
              onNextAction: Action?) {
        addToWindow()
        stackDescription.removeFullyAllArrangedSubviews()
        addressLabel.text = address
        setBackgroundColor(color: .clear)
        titleLabel.text = title
        btnNext.setTitle(titleButton, for: .normal)
        stackDescription.addArrangedSubview(BulletedListView(caution: "dialog_smart_contract_warning_content1".Localizable(),
                                                             font: UIFont.primary(size: 14.0), color: UIColor(hexString: "#F25D4E")))
        stackDescription.addArrangedSubview(BulletedListView(caution: "dialog_smart_contract_warning_content2".Localizable(),
                                                             font: UIFont.primary(size: 14.0), color: UIColor.color_7b7b7b_b6b6b6))
        btnNext.did(.touchUpInside) { _, _ in
            onNextAction?()
            self.removeToWindow()
        }
        backView.addTapGesture{
            self.removeToWindow()
        }
    }
    
    func removeToWindow() {
        self.removeFromSuperview()
    }
    
}


