//
//  TickerSectionItem.swift
//  Probit
//
//  Created by Nguyen Quang on 09/09/2022.
//

import UIKit

class TickerSectionItem: BaseView {
    
    // MARK: - IBOutlet
    @IBOutlet weak var containerView: HighlightView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var traddingPairLabel: UILabel!
    
    // MARK: - Private Variable
    private let market: Market?
    private var marketData: MarketData?

    // MARK: - Public Variable
    weak var delegate: HomeSectionProtocol?
    let id: String?
    var price: String?
    let baseCurrencyID: String?
    
    // MARK: - Lifecycle
    init(model: Market?) {
        market = model
        id = model?.id
        baseCurrencyID = model?.baseCurrencyID
        super.init()
        settingView(model: model)
        setupDarkMode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDarkMode() {
        containerView.backgroundColor = UIColor.color_f5f5f5_282828
        containerView.borderColor = UIColor.color_e6e6e6_424242
        containerView.bgColor = UIColor.color_f5f5f5_282828
        containerView.highlightType = .homeTicker
    }
    
    func settingView(model: Market?) {
        priceLabel.text = "--"
        stateLabel.text = "--"
        nameLabel.text = model?.baseCurrencyID
        traddingPairLabel.text = model?.quoteCurrencyID
        
        updateTicker(data: model?.tickers)
        
        guard let id = model?.baseCurrencyID else { return }
        loadImage(id: id)
        let tap = UITapGestureRecognizer(target: self, action: #selector(itemSectionDidTap))
        containerView.addGestureRecognizer(tap)
    }
    
    func loadImage(id: String) {
        LoadImageUrl.shared.cryptoCurrencyImage(with: id, in: logoImage)
    }
    
    public func reload() {
        updateTicker(marketData: marketData)
    }
    
    func updatePrice(usdtRate: String?) {
        guard let usdtRate = usdtRate else {
            priceLabel.text = "--"
            return
        }
        self.price = usdtRate
        if let rate = usdtRate.doubleValue() {
            let price = rate.fractionDigits(min: 2,max: 6 , roundingMode: .ceiling)
            priceLabel.text = price
        }
    }
    
    func updateTicker(marketData: MarketData?) {
        self.marketData = marketData
        guard let ticker = marketData?.ticker,
              let usdtRate = ticker.last?.doubleValue(),
              usdtRate != 0.0 else { return }
        let tickerColor = AppConstant.tickerColor
        let value = ticker.change24Hr() ?? 0.0
        let fractionDigitsValue = abs(value).fractionDigits(min: 2, max: 2, roundingMode: .ceiling)
        let fractionDigitsValueRtl = value < 0.0 ? "\(fractionDigitsValue)%-" : "\(fractionDigitsValue)%+"
        let fractionDigitsValueLtr = value < 0.0 ? "-\(fractionDigitsValue)%" : "+\(fractionDigitsValue)%"
        stateLabel.text = AppConstant.isLanguageRightToLeft ? fractionDigitsValueRtl : fractionDigitsValueLtr
        priceLabel.textColor = value < 0.0 ? tickerColor.sellColor : tickerColor.buyColor
        stateLabel.textColor = value < 0.0 ? tickerColor.sellColor : tickerColor.buyColor
    }
    
    func updateTicker(data: Ticker?) {
        guard let ticker = data,
              let usdtRate = ticker.last?.doubleValue(),
              usdtRate != 0.0 else { return }
        let tickerColor = AppConstant.tickerColor
        let value = ticker.change24Hr() ?? 0.0
        let fractionDigitsValue = abs(value).fractionDigits(min: 2, max: 2, roundingMode: .ceiling)
        let fractionDigitsValueRtl = value < 0.0 ? "\(fractionDigitsValue)%-" : "\(fractionDigitsValue)%+"
        let fractionDigitsValueLtr = value < 0.0 ? "-\(fractionDigitsValue)%" : "+\(fractionDigitsValue)%"
        stateLabel.text = AppConstant.isLanguageRightToLeft ? fractionDigitsValueRtl : fractionDigitsValueLtr
        priceLabel.textColor = value < 0.0 ? tickerColor.sellColor : tickerColor.buyColor
        stateLabel.textColor = value < 0.0 ? tickerColor.sellColor : tickerColor.buyColor
    }
    
    @objc func itemSectionDidTap(_ sender: Any) {
        guard let id = id else { return }
        delegate?.navigateToExchangeDetail(exchangeId: id)
    }
}
