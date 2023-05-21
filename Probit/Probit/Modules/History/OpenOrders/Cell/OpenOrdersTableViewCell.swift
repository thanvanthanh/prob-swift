//
//  OpenOrdersTableViewCell.swift
//  Probit
//
//  Created by Nguyen Quang on 29/08/2022.
//

import UIKit

class OpenOrdersTableViewCell: BaseTableViewCell {

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cancelButton: HighlightButon!
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountTitleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var filledTitleLabel: UILabel!
    @IBOutlet weak var filledLabel: UILabel!
    @IBOutlet weak var totalTitleLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var doCancel: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        [priceLabel, amountLabel, filledLabel, totalLabel].forEach {
            $0?.textAlignment = isRTL ? .left : .right
        }
    }
    
    override func localizable() {
        priceTitleLabel.text = "marketlist_price".Localizable()
        amountTitleLabel.text = "orderform_amount".Localizable()
        filledTitleLabel.text = "viewholder_history_orderhistory_filled".Localizable()
        totalTitleLabel.text = "orderform_total".Localizable()
    }

    override func setupCell(object: Any) {
        if let order = object as? OrderDataModel {
            nameLabel.text = order.marketID?.replacingOccurrences(of: "-", with: "/")
            setupSellButton(bgColor: order.side?.getColorBG(order.status),
                            mainColor: order.side?.getColorMain(order.status),
                            title: order.side?.title)
            timeLabel.text = order.time.stringFromDateWithSemantic()
            priceLabel.text = order.type == .MARKET ? "orderform_market".Localizable() : order.limitPrice?.asDouble().fractionDigits(min: 0)
            amountLabel.text = order.quantity?.asDouble().fractionDigits(min: 0)
            filledLabel.text = order.filledQuantity
            totalLabel.text = order.filledCost?.asDouble().fractionDigits(min: 0)
            updateUICancelButton(status: order.status)
            cancelButton.isHidden = false
        }
        
        if let tradeHistory = object as? TradeHistoryModel {
            nameLabel.text = tradeHistory.marketID?.replacingOccurrences(of: "-", with: "/")
            timeLabel.text = tradeHistory.time.stringFromDateWithSemantic()
            priceLabel.text = tradeHistory.price?.asDouble().fractionDigits(min: 0)
            amountLabel.text = tradeHistory.quantity?.asDouble().fractionDigits(min: 0)
            filledLabel.text = "\(tradeHistory.feeAmount ?? "") \(tradeHistory.feeCurrencyID ?? "")"
            totalLabel.text = tradeHistory.cost?.asDouble().fractionDigits(min: 0) ?? "0"
            setupSellButton(bgColor: tradeHistory.side?.getColorBG(nil),
                            mainColor: tradeHistory.side?.getColorMain(nil),
                            title: tradeHistory.side?.title)
            filledTitleLabel.text = "viewholder_history_tradehistory_fee".Localizable()
            cancelButton.isHidden = true
        }
    }
    
    @IBAction func doCancelAction(_ sender: Any) {
        self.doCancel?()
    }
    
    func setupSellButton(bgColor: UIColor?, mainColor: UIColor?, title: String?) {
        sellButton.setTitle(title, for: .normal)
        sellButton.setTitleColor(mainColor, for: .normal)
        sellButton.backgroundColor = bgColor
    }
    
    func updateUICancelButton(status: OrderStatus?) {
        if status == .OPEN {
            let grayColor = UIColor.color_4231c8_6f6ff7
            cancelButton.setTitle("dialog_cancel".Localizable(), for: .normal)
            cancelButton.layer.borderWidth = 1
            cancelButton.layer.cornerRadius = 2
            cancelButton.bgColor = .clear
            cancelButton.textColor = grayColor
            cancelButton.strokeColor = grayColor
            cancelButton.highlightType = .outlineButton1
            
            
            cancelButton.contentEdgeInsets = .init(top: 10, left: 16, bottom: 10, right: 16)
        } else {
            let mainColor = UIColor.color_282828_7b7b7b
            cancelButton.setTitle(status?.rawValue.capitalized ?? "none", for: .normal)
            cancelButton.layer.borderWidth = 0
            cancelButton.tintColor = mainColor
            cancelButton.setImage(nil, for: .normal)
            cancelButton.setTitleColor(mainColor, for: .normal)
            cancelButton.contentEdgeInsets = .zero
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
