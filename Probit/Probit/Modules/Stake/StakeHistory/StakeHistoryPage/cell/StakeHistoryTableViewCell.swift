//
//  StakeHistoryTableViewCell.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 06/10/2565 BE.
//

import UIKit

class StakeHistoryTableViewCell: BaseTableViewCell {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var endStake: UILabel!
    @IBOutlet weak var startStake: UILabel!
    @IBOutlet weak var titleValue: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var viewDots: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }
    
    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        [startStake, titleLabel].forEach { $0.textAlignment = isRTL ? .right : .left }
        [endStake, titleValue].forEach { $0.textAlignment = isRTL ? .left : .right }
    }
    
    override func setupCell(object: Any) {
        guard let data = object as? StakeDetailModel else { return }
        titleValue.text = data.amount?.asDouble().fractionDigits(min: 6, max: 8, roundingMode: .up)
        let startDate = data.stakeTime?.toDate() ?? Date()
        let endDate = data.stakedTime?.toDate() ?? Date()
        startStake.text = startDate.stringFromDateWithSemantic(gmtFormat: "")
        endStake.text = endDate.stringFromDateWithSemantic(gmtFormat: "")
        progressBar.progress = Float(Date().percentInBetweenDate(startDate: startDate, endDate: endDate))
        progressBar.tintColor = data.stakeType.colors
        viewDots.backgroundColor = data.stakeType.colors
    }
    
}
