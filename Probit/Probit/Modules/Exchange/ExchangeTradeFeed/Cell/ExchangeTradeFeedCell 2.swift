//
//  ExchangeTradeFeedCell.swift
//  Probit
//
//  Created by Nguyen Quang on 17/10/2022.
//

import UIKit

class ExchangeTradeFeedCell: BaseTableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupCell(object: Any) {
        guard let model = object as? RecentTrade else { return }
        let price = model.price.doubleValue()?.fractionDigits(min: 1, max: 8, roundingMode: .ceiling)
        priceLabel.text = price

        let quantity = model.quantity.doubleValue()?.fractionDigits(min: 4, max: 8, roundingMode: .ceiling)
        amountLabel.text = quantity
        
        timeLabel.text = model.date?.stringFromDate(format: "HH:mm:ss")
        priceLabel.textColor = model.orderSide == .SELL ? UIColor.Basic.red : UIColor.Basic.green
    }
}
