//
//  StakeCollectionViewCell.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 22/09/2565 BE.
//

import UIKit

class StakeCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var percenLabel: UILabel!
    @IBOutlet weak var stakeView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }
    
    func setupUI() {
        stakeView.cornerRadius = 6.0
    }
    
    override func setupCell(object: Any) {
        guard let data = object as? StakeProgressArg else { return }
        if let annualRate = data.rule.reward?.annualRate?.doubleValue() {
            percenLabel.text = "\((annualRate * 100).fractionDigits(min: 0,max: 2))%"
        }
        dayLabel.isHidden = data.hiddenDay
        if let time = data.rule.cond?.period {
            dayLabel.text = time.hourToString
        }
    }

}
