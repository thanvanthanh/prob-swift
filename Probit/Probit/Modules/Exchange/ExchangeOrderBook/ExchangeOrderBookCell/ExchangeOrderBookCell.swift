//
//  ExchangeOrderBookCell.swift
//  Probit
//
//  Created by Nguyen Quang on 17/10/2022.
//

import UIKit

class ExchangeOrderBookCell: UITableViewCell {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var blurBackgroundView: UIView!
    @IBOutlet weak var withBlurBackgroundConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var darkBackgroundView: UIView!
    @IBOutlet weak var withDarkBackgroundConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        priceLabel.text = nil
        amountLabel.text = nil
        totalLabel.text = nil
        blurBackgroundView.backgroundColor = nil
        darkBackgroundView.backgroundColor = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCellWith(_ order: OrderBook,
                        indexPath: IndexPath? = nil,
                        maxTotal: String?,
                        screenParent: OrderBookScreenParrent = .normal) {
        let tickerColor = AppConstant.tickerColor
        // PRICE
        let price = order.price.doubleValue()?.fractionDigits(min: 1, roundingMode: .halfEven)
        priceLabel.textColor = order.isEmpty ? UIColor.color_white_black : order.orderSide == .SELL ? tickerColor.sellColor : tickerColor.buyColor
        priceLabel.text = order.isEmpty ? "-" : price
        
        // QUANTITY
        let quantity = order.quantity.doubleValue()?.fractionDigits(min: 4, max: 4)
        amountLabel.text = order.isEmpty ? "-" : quantity
        if(screenParent == .detail) { amountLabel.textAlignment = .right }
        
        let total = order.total?.doubleValue()?.fractionDigits(min: 4, max: 4)
        totalLabel.text = order.isEmpty ? "-" : total
        setupStateTotalView(model: order, maxTotal: maxTotal, screenParent: screenParent)
        
        blurBackgroundView.backgroundColor = order.isEmpty ? nil : order.orderSide.getBackgroundColorBlurViewExchange(isDarkMode: isDarkMode)
        darkBackgroundView.backgroundColor = order.isEmpty ? nil : order.orderSide.getBackgroundColorDarkViewExchange(isDarkMode: isDarkMode)
        
        totalLabel.isHidden = screenParent == .detail
    }
        
    private func setupStateTotalView(model: OrderBook, maxTotal: String?, screenParent: OrderBookScreenParrent) {
        guard let maxTotal = maxTotal?.asDouble(),
              let currentTotal = model.total?.asDouble(),
              currentTotal > 0.0 else {
            return
        }
        let quantity = model.quantity.asDouble()
        
        let ratioDark = CGFloat(quantity/maxTotal)
        let ratioBlur = CGFloat(currentTotal / maxTotal)
        
        let widthScreen = screenParent == .normal ? UIScreen.main.bounds.width : UIScreen.main.bounds.width / 2
        let width = maxTotal == currentTotal ? widthScreen : widthScreen - 5
        
        withBlurBackgroundConstraint.constant = width * ratioBlur
        withDarkBackgroundConstraint.constant = width * ratioDark
    }
}

extension OrderSide {
    
    func getBackgroundColorBlurViewExchange(isDarkMode: Bool) -> UIColor {
        let tickerColor = AppConstant.tickerColor
        
        if tickerColor == .option1 {
            if self == .BUY {
                return isDarkMode ? tickerColor.buyColor.withAlphaComponent(0.1) : UIColor(hexString: "EEFFF7")
            } else {
                return isDarkMode ? tickerColor.sellColor.withAlphaComponent(0.1) : UIColor(hexString: "FFEEF0")
            }
        } else {
            if self == .BUY {
                return isDarkMode ? tickerColor.buyColor.withAlphaComponent(0.1) : UIColor(hexString: "FFEEF0")
            } else {
                return isDarkMode ? tickerColor.sellColor.withAlphaComponent(0.1) : UIColor(hexString: "D9D6F4")
            }
        }

    }

    func getBackgroundColorDarkViewExchange(isDarkMode: Bool) -> UIColor {
        let tickerColor = AppConstant.tickerColor
        
        if tickerColor == .option1 {
            if self == .BUY {
                return isDarkMode ? tickerColor.buyColor.withAlphaComponent(0.2) : UIColor(hexString: "DBFBEC")
            } else {
                return isDarkMode ? tickerColor.sellColor.withAlphaComponent(0.2) : UIColor(hexString: "FCDDE1")
            }
        } else {
            if self == .BUY {
                return isDarkMode ? tickerColor.buyColor.withAlphaComponent(0.2) : UIColor(hexString: "FCDDE1")
            } else {
                return isDarkMode ? tickerColor.sellColor.withAlphaComponent(0.2) : UIColor(hexString: "8E83D3")
            }
        }
    }
}

enum OrderBookScreenParrent {
    case normal
    case detail
}

extension TickerColor {
    var blurBuyColor: UIColor {
        switch self {
        case .option1: return UIColor(hexString: "EEFFF7")
        case .option2: return UIColor(hexString: "FFEEF0")
        }
    }
    
    var blurSellColor: UIColor {
        switch self {
        case .option1: return UIColor(hexString: "EEFFF7")
        case .option2: return UIColor(hexString: "FFEEF0")
        }
    }
}
