//
//  ReferralTokenView.swift
//  Probit
//
//  Created by Thân Văn Thanh on 14/10/2022.
//

import UIKit

class ReferralTokenView: BaseView {

    @IBOutlet private weak var iconImage: UIImageView!
    @IBOutlet private weak var tokenName: UILabel!
    @IBOutlet private weak var tokenCount: UILabel!
    
    func setupStack(model: ReferrerEarnedModel) {
        backgroundColor = .clear
        tokenName.text = model.name
        tokenCount.text = model.value.string.replaceCurrency()
        iconImage.loadCurrencyImage(WalletCurrency.generator(model.name, .crypto))
    }
}
