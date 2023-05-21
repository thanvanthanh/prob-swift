//
//  TradingPrizesTableViewCell.swift
//  Probit
//
//  Created by Nguyen Quang on 23/09/2022.
//

import UIKit

class TradingPrizesTableViewCell: BaseTableViewCell {

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var spacingBottom: UIView!
    
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
        guard let model = object as? TradingPrizeList else { return }
        rankLabel.text = model.rankNumber
        valueLabel.text = model.amount
    }
}
