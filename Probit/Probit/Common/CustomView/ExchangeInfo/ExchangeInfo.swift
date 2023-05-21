//
//  ExchangeInfo.swift
//  Probit
//
//  Created by Nguyen Quang on 21/10/2022.
//

import UIKit

class ExchangeInfo: BaseView {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var usdtRate: UILabel!
    @IBOutlet weak var volLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    
    public func updateUsdtRate(rate: String) {
        usdtRate.text = AppConstant.isLanguageRightToLeft ? "≈ USDT \(rate)" : "≈ \(rate) USDT"
    }
    
    override func setupUI() {
        setupRightToLeft(AppConstant.isLanguageRightToLeft)
    }
    
    public func updateExchangeData(ticker: ExchangeTicker) {
        let price = ticker.quoteRate.doubleValue()
        usdtRate.isHidden = ticker.id.value.contains(find: "USDT")
        priceLabel.text = price?.fractionDigits(min: 2, max: ticker.quoteRate.digitNumber ?? 8, roundingMode: .down) ?? "-"
        buildVolLabel(vol: ticker.quoteVolume ?? "-")
        build24ChangeLabel(change: ticker.change24Hr())
    }
    
    private func setupRightToLeft(_ status: Bool) {
        [priceLabel, usdtRate].forEach{ $0.textAlignment = status ? .right : .left }
        [volLabel, changeLabel].forEach { $0?.textAlignment = status ? .left : .right }
        
    }
    
    private func build24ChangeLabel(change: Double?) {
        var changeValue: String = "-"
        var color: UIColor = .color_282828_fafafa
        
        if let change = change {
            let fractionDigitsValue = abs(change).fractionDigits(min: 2, max: 2, roundingMode: .ceiling)
            let changeValueLtr = change <= 0.0 ? "-\(fractionDigitsValue)%" : "+\(fractionDigitsValue)%"
            let changeValueRtl = change <= 0.0 ? "\(fractionDigitsValue)%-" : "\(fractionDigitsValue)%+"
            changeValue = AppConstant.isLanguageRightToLeft ? changeValueRtl : changeValueLtr
            
            let ticker = AppConstant.tickerColor
            color = change == 0.0 ? .color_282828_fafafa : (change < 0.0 ? ticker.sellColor : ticker.buyColor)
        }
        var text = ""
        if AppConstant.isLanguageRightToLeft {
            text = changeValue + " " + "marketlist_changerate".LocalizableRtl()
        } else {
            text = "marketlist_changerate".Localizable() + " " + changeValue
        }

        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.apply(color: UIColor.color_b6b6b6_7b7b7b, subString: text)
        attributedText.apply(font: .primary(size: 14), subString: text)
        attributedText.apply(color: color, subString: changeValue)

        changeLabel.attributedText = attributedText
    }
    
    private func buildVolLabel(vol: String) {
        let value = vol.doubleValue()?.fractionDigits(min: 2, max: 2, roundingMode: .down) ?? "-"
        var text = ""
        if AppConstant.isLanguageRightToLeft {
            text = value + " " + "marketlist_volume".LocalizableRtl()
        } else {
            text = "marketlist_volume".Localizable() + " " + value
        }
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.apply(color: UIColor.color_b6b6b6_7b7b7b, subString: text)
        attributedText.apply(font: .primary(size: 14), subString: text)
        attributedText.apply(color: UIColor.color_282828_06_e6e6e6, subString: value)
        attributedText.apply(font: .medium(size: 14), subString: value)
        volLabel.attributedText = attributedText
    }
}
