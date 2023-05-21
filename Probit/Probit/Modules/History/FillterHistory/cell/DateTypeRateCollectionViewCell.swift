//
//  DateTypeRateCollectionViewCell.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 13/10/2565 BE.
//

import UIKit

class DateTypeRateCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var viewDayContent: HighlightView!
    @IBOutlet weak var dayLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func billData(title: String,
                  isSelected: Bool,
                  textColor: UIColor = UIColor.color_c8c8c8_b6b6b6,
                  borderColor: UIColor = UIColor.color_e6e6e6_424242) {
        dayLabel.text = title
        setSelected(isSelected: isSelected, textColor: textColor, borderColor: borderColor)
    }
    
    func setSelected(isSelected: Bool,
                     textColor: UIColor = UIColor.color_c8c8c8_b6b6b6,
                     borderColor: UIColor = UIColor.color_e6e6e6_424242) {
        let textColor =  isSelected ? UIColor.color_4231c8_6f6ff7 : textColor
        dayLabel.textColor = textColor
        viewDayContent.borderColor = borderColor
        
        if isSelected {
            viewDayContent.setStateApplyHover(false)
            viewDayContent.borderColor = UIColor.color_4231c8_6f6ff7
            viewDayContent.backgroundColor = .color_4231c8_6f6ff7.withAlphaComponent(0.1)
        } else {
            viewDayContent.setStateApplyHover(true)
            viewDayContent.bgColor = .clear
            viewDayContent.strokeColor = borderColor
            viewDayContent.highlightType = .outlineButton2
        }
        
    }
    
    func setBackgroundSelected(isSelected: Bool) {
        
    }
}
