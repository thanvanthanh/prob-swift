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
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
