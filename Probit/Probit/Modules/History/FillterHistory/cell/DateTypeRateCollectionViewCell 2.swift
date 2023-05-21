//
//  DateTypeRateCollectionViewCell.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 13/10/2565 BE.
//

import UIKit

class DateTypeRateCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewDayContent: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func billData(dateRate: DateRateType, isSelected: Bool) {
        dayLabel.text = dateRate.title
        let textColor =  isSelected ? UIColor.init(named: "color_4231c8_6f6ff7") : UIColor.init(named: "color_c8c8c8_b6b6b6")
        let borderColor =  isSelected ? UIColor.init(named: "color_4231c8_6f6ff7") : UIColor.init(named: "color_e6e6e6_424242")
        dayLabel.textColor = textColor
        viewDayContent.borderColor = borderColor
        viewDayContent.backgroundColor = isSelected ? (UIColor.init(named: "color_4231c8_6f6ff7") ?? .clear).withAlphaComponent(0.1) : .clear
    }
}
