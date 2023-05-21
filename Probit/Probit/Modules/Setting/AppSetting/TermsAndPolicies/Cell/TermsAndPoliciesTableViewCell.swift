//
//  TermsAndPoliciesTableViewCell.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//

import UIKit

class TermsAndPoliciesTableViewCell: BaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var showTermsButton: UIButton!
    @IBOutlet weak var termsSwitch: UISwitch!
    @IBOutlet weak var bottomView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        termsSwitch.semanticContentAttribute = .forceLeftToRight
        // Initialization code
    }
    
    override func setupCell(object: Any) {
        guard let model = object as? TermSetting else { return }
        bottomView.isHidden = model.name != .personalInfo && model.name != .nightTime
        titleLabel.text = model.name.title
        hintLabel.text = model.name.hintTitle
        showTermsButton.setTitle(model.name.buttonTitle, for: .normal)
        showTermsButton.underline()
        termsSwitch.setOn(model.isSwitch && model.isEnableSwitch, animated: false)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
