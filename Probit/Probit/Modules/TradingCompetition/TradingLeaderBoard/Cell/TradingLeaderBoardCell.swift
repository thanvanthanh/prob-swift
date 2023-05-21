//
//  TradingLeaderBoardCell.swift
//  Probit
//
//  Created by Nguyen Quang on 25/09/2022.
//

import UIKit

class TradingLeaderBoardCell: BaseTableViewCell {
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var convertedTitleLabel: UILabel!
    @IBOutlet weak var emailValueLabel: UILabel!
    @IBOutlet weak var convertedValueLabel: UILabel!
    @IBOutlet weak var parentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        emailTitleLabel.text = "\("tradecompetition_leaderboard_item_email".Localizable()) "
        convertedTitleLabel.text = "\("tradecompetition_leaderboard_item_convertedusdt".Localizable())"
        parentView.backgroundColor = UIColor.color_ffffff_2a2a2a
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func setupCell(object: Any) {
        guard let model = object as? LeaderboardData else { return }
        emailValueLabel.text = model.email
        rankLabel.text = "\("tradecompetition_leaderboard_item_rank".Localizable()) \(model.rank.string)"
        
        guard let volume = model.volume else {
            convertedValueLabel.text = " -"
            return
        }
        convertedValueLabel.text = "\(volume.string)"
    }
}
