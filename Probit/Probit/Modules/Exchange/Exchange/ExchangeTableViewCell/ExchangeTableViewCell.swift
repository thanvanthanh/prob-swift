//
//  ExchangeTableViewCell.swift
//  Probit
//
//  Created by Nguyen Quang on 26/08/2022.
//

import UIKit

class ExchangeTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var usdtPriceLabel: UILabel!
    @IBOutlet weak var growthLabel: UILabel!
    @IBOutlet weak var volLabel: UILabel!
    @IBOutlet weak var volUsdtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.image = nil
        nameLabel.text = nil
        typeLabel.text = nil
        priceLabel.text = nil
        growthLabel.text = nil
        volLabel.text = nil
    }
    
    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        volLabel.textAlignment = isRTL ? .left : .right
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupCell(object: Any) {
        guard let model = object as? ExchangeTicker else { return }
        let widthContainer = UIScreen.main.bounds.width - 16 - 16
        let widthPriceLabel = widthContainer * 69 / 375
        let widthVoidLabel = widthContainer * 98 / 375
        let widthNameLabel = (widthContainer - widthPriceLabel - widthVoidLabel - widthPriceLabel) - 8 * 3 - 26

        setupNameLabel(displayName: model.displayName, maxWidth: widthNameLabel)
        setupVolLabel(quoteVolume: model.quoteVolume, maxWidth: widthVoidLabel)
        setupPriceLabel(usdtRate: model.quoteRate, maxWidth: widthPriceLabel)
        updateTicker(model: model)
        typeLabel.text = "\(model.baseCurrencyId ?? "-")/\(model.quoteCurrencyId ?? "-")"
        self.updateUsdtPrice(model)
        guard let id = model.baseCurrencyId else { return }
        LoadImageUrl.shared.cryptoCurrencyImage(with: id, in: avatarView)
    }
    
    // setup UI name label
    private func setupNameLabel(displayName: String?, maxWidth: CGFloat) {
        guard let displayName = displayName else {
            nameLabel.text = "-"
            nameLabel.font = .font(style: .regular, size: 16)
            return
        }
        setupStyleLabel(label: nameLabel, width: maxWidth, text: displayName)
    }
    
    // setup UI price label
    private func setupPriceLabel(usdtRate: String?, maxWidth: CGFloat) {
        guard let usdtRate = usdtRate?.doubleValue(), usdtRate > 0 else {
            priceLabel.text = "-"
            usdtPriceLabel.text = "_"
            priceLabel.font = .font(style: .regular, size: 16)
            return
        }
        let price = usdtRate.fractionDigits(min: 2, max: 10, roundingMode: .down)
        setupStyleLabel(label: priceLabel, width: maxWidth, text: price)
    }
    
    // setup UI vol label
    private func setupVolLabel(quoteVolume: String?, maxWidth: CGFloat) {
        guard let quoteVolume = quoteVolume?.doubleValue(), quoteVolume > 0 else {
            volLabel.text = "-"
            volUsdtLabel.text = "_"
            volLabel.font = .font(style: .regular, size: 16)
            return
        }
        let price = quoteVolume.fractionDigits(min: 2, max: 2, roundingMode: .down)
        setupStyleLabel(label: volLabel, width: maxWidth, text: price)
    }
    
    private func updateUsdtPrice(_ ticker: ExchangeTicker) {
        let isUnitUSDT: Bool = ticker.quoteCurrencyId?.lowercased() == "usdt"
        self.usdtPriceLabel.isHidden = isUnitUSDT
        self.volUsdtLabel.isHidden = isUnitUSDT
        
        
        if let rate = ticker.changeRate, let price = Double(ticker.quoteRate) {
            let usdtPrice = (rate * price).fractionDigits(min: 2, max: 6, roundingMode: .down)
            self.usdtPriceLabel.text = AppConstant.isLanguageRightToLeft ? "USDT \(usdtPrice)" : "\(usdtPrice) USDT"
            self.usdtPriceLabel.isHidden = false
        } else {
            self.usdtPriceLabel.isHidden = true
        }
        
        if let rate = ticker.changeRate, let volume = Double(ticker.quoteVolume ?? "") {
            let usdtPrice = (rate * volume).fractionDigits(min: 2, max: 3, roundingMode: .down)
            self.volUsdtLabel.text = AppConstant.isLanguageRightToLeft ? "USDT \(usdtPrice)" : "\(usdtPrice) USDT"
            self.volUsdtLabel.isHidden = false
        } else {
            self.volUsdtLabel.isHidden = true
        }
    }
    
    private func updateTicker(model: ExchangeTicker?) {
    
        if model?.change24Hr() == nil {
            growthLabel.text = "-"
            growthLabel.textColor =  UIColor.color_white_black
            priceLabel.textColor = UIColor.color_white_black
        }
        else if (model?.change24Hr() ?? 0) == 0 {
            growthLabel.text = "0.00%"
            growthLabel.textColor =  UIColor.color_white_black
            priceLabel.textColor = UIColor.color_white_black
        } else {
            let change24h = model?.change24Hr() ?? 0
            let fractionDigitsValue = abs(change24h).fractionDigits(min: 2, max: 2, roundingMode: .ceiling)
            let downChange = AppConstant.isLanguageRightToLeft ? "\(fractionDigitsValue)%-" : "-\(fractionDigitsValue)%"
            let upChange = AppConstant.isLanguageRightToLeft  ? "\(fractionDigitsValue)%+" : "+\(fractionDigitsValue)%"
            growthLabel.textColor = change24h < 0.0 ? model?.tickerColor.sellColor : model?.tickerColor.buyColor
            growthLabel.text =  change24h < 0.0 ? downChange : upChange
            priceLabel.textColor =  change24h <= 0.0 ? model?.tickerColor.sellColor : model?.tickerColor.buyColor
        }
    }
    
    private func setupStyleLabel(label: UILabel, width: CGFloat, text: String) {
        let labelDraft = UILabel()
        labelDraft.text = text
        labelDraft.font = .font(style: .regular, size: 16)
        let labelWidth = labelDraft.getSize(constrainedWidth: width).width
        label.font = labelWidth > width ? .font(style: .regular, size: 12) : .font(style: .regular, size: 16)
        label.text = text
    }
}

extension UILabel {
    func getSize(constrainedWidth: CGFloat) -> CGSize {
        return systemLayoutSizeFitting(CGSize(width: constrainedWidth,
                                              height: UIView.layoutFittingCompressedSize.height),
                                       withHorizontalFittingPriority: .required,
                                       verticalFittingPriority: .fittingSizeLevel)
    }
}
