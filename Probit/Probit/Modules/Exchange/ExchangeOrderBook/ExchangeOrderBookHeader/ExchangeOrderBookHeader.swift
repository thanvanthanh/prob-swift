//
//  ExchangeOrderBookHeader.swift
//  Probit
//
//  Created by Nguyen Quang on 18/10/2022.
//

import UIKit

class ExchangeOrderBookHeader: BaseView {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var usdtPriceLabel: UILabel!
    @IBOutlet weak var stateImage: UIImageView!
    
    
    func updatePrice(price: String, tickDerection: TickDirection) {
        self.backgroundColor = UIColor(hexString: "F2F2F2")
        let price = price.doubleValue()?.fractionDigits(min: 1, roundingMode: .ceiling)
        priceLabel.text = price
        priceLabel.textColor = tickDerection.color
        stateImage.image = tickDerection.icon
        stateImage.backgroundColor = tickDerection.color
    }
    
    func updateUsdtRate(usdtPrice: String?) {
        self.backgroundColor = UIColor(hexString: "F2F2F2")
        if let usdtPrice = usdtPrice, !usdtPrice.isEmpty {
            usdtPriceLabel.isHidden = false
            usdtPriceLabel.text = AppConstant.isLanguageRightToLeft ? "≈ USDT \(usdtPrice)":"≈ \(usdtPrice) USDT"
        } else {
            usdtPriceLabel.isHidden = true
        }
    }
}
