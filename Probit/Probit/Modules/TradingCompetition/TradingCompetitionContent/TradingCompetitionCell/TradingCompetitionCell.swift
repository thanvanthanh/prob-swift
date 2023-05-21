//
//  TradingCompetitionCell.swift
//  Probit
//
//  Created by Nguyen Quang on 22/09/2022.
//

import UIKit

class TradingCompetitionCell: BaseTableViewCell {
    
    @IBOutlet weak var boostButton: BoosterView!
    @IBOutlet weak var boostView: UIView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var gradienStateView: UIButton!
    @IBOutlet weak var normalStateView: UIButton!
    
    var trading: Trading?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.image = nil
        titleLabel.text = nil
        totalLabel.text = nil
        gradienStateView.setTitle(nil, for: .normal)
        normalStateView.setTitle(nil, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupCell(object: Any) {
        guard let model = object as? Trading else { return }
        self.trading = model
        iconView.setImage(model.logoImage)
        titleLabel.text = model.eventNameEn
        totalLabel.text = model.prizeTotalEn
        boostView.isHidden = model.boost == nil
        gradienStateView.setTitle(model.titleTrading, for: .normal)
        normalStateView.setTitle(model.titleTrading, for: .normal)
        normalStateView.backgroundColor = model.stakeEventType?.colors.first

        if model.boost != nil {
            boostButton.activeView()
        }
        guard let eventType = model.stakeEventType, eventType == .RUNNING else {
            normalStateView.isHidden = false
            gradienStateView.isHidden = true
            return
        }
        normalStateView.isHidden = true
        gradienStateView.isHidden = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradienStateView.applyGradient(colours: [UIColor(hexString: "#22D1A3"), UIColor.Basic.blue])
    }
}
