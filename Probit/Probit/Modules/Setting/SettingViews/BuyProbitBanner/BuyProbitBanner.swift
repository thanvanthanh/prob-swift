//
//  BuyProbitBanner.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/10/2022.
//

import UIKit

@IBDesignable class BuyProbitBanner: BaseView {

    @IBOutlet private weak var buyProBitButton: UIButton!
    @IBOutlet private weak var buyProBitLabel: UILabel!
    
    // MARK: - Lifecycle
    override func setupUI() {
        super.setupUI()
        buyProBitLabel.textAlignment = AppConstant.isLanguageRightToLeft ? .right : .left
    }
    
    override func localizedString() {
        buyProBitLabel.text = "fragment_settings_v2_purchaseprob_title".Localizable()
    }
    
    func getAction(buyProb: @escaping Action) {
        buyProBitButton.did(.touchUpInside) { _, _ in
            buyProb()
        }
    }
}
