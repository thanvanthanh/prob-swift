//
//  PurchaseHistoryTableViewCell.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 20/10/2565 BE.
//

import UIKit

class PurchaseHistoryTableViewCell: BaseTableViewCell {
    
    
    @IBOutlet weak var viewDots: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    
    
    @IBOutlet private weak var priceValue: UILabel!
    @IBOutlet private weak var amountValue: UILabel!
    @IBOutlet private weak var totalValue: UILabel!
    
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    
    @IBOutlet private weak var timeValue: UILabel!

    override func localizable() {
        priceLabel.text = "orderform_price".Localizable()
        amountLabel.text = "orderform_amount".Localizable()
        totalLabel.text = "orderform_total".Localizable()
        titleLabel.text = "viewholder_buy_prob_history_done".Localizable()
        titleLabel.font = .font(style: .medium, size: 16)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupCell(object: Any) {
        guard let data = object as? PurchaseModel else { return }
        priceValue.text = data.price?.asDouble().fractionDigits(min: 0, max: 8, roundingMode: .down)
        amountValue.text = data.toQuantity?.asDouble().fractionDigits(min: 0, max: 8, roundingMode: .down)
        totalValue.text = data.fromQuantity?.asDouble().fractionDigits(min: 0, max: 8, roundingMode: .down)
        timeValue.text = data.time.stringFromDateWithSemantic()
        if let fromCurrencyID = data.fromCurrencyID, !(data.toCurrencyID?.isEmpty ?? false){
            subTitleLabel.text = "\(fromCurrencyID)"
        }
    }
}
