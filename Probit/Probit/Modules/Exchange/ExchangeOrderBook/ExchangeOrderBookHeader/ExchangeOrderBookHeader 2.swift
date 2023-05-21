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
    
    func updatePrice(price: String, state: OrderSide) {
        let price = price.doubleValue()?.fractionDigits(min: 1, roundingMode: .ceiling)
        priceLabel.text = price
        priceLabel.textColor = state == .SELL ? UIColor.Basic.red : UIColor.Basic.green
        stateImage.image = state == .SELL ? UIImage(named: "ico_sell") : UIImage(named: "ico_buy")
    }
}
