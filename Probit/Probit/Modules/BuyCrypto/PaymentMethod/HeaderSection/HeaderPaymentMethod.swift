//
//  HeaderPaymentMethod.swift
//  Probit
//
//  Created by Thân Văn Thanh on 20/09/2022.
//

import UIKit

class HeaderPaymentMethod: BaseView {
    
    @IBOutlet weak var choosePaymentTitle: UILabel!
    @IBOutlet weak var spendTitle: UILabel!
    @IBOutlet weak var amountTitle: UILabel!
    @IBOutlet weak var amountTypeTitle: UILabel!

    func bindingData(data: PamentChanelParameters) {
        choosePaymentTitle.text = "buycrypto_choosepayment_title".Localizable()

        if data.isSpend {
            spendTitle.text = "buycrypto_spend".Localizable()
            amountTitle.text = data.fiatAmount
            amountTypeTitle.text = data.fiat
        } else {
            spendTitle.text = "buycrypto_receive".Localizable()
            amountTitle.text = data.cryptoAmount
            amountTypeTitle.text = data.crypto
        }
    }

}
