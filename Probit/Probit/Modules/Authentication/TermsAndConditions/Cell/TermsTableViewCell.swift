//
//  TermsTableViewCell.swift
//  Probit
//
//  Created by Nguyen Quang on 22/08/2022.
//

import UIKit

class TermsTableViewCell: BaseTableViewCell {
    @IBOutlet weak var viewMoreButton: UIButton!
    @IBOutlet weak var viewMore: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mandatoryLabel: UILabel!
    @IBOutlet weak var checkView: UIImageView!
    @IBOutlet weak var termContainerView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        setStateApplyHover(false)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupCell(object: Any) {
        guard let model = object as? Terms  else { return }
        emptyView.isHidden = model.name != .all
        viewMore.isHidden = model.name == .all
        termContainerView.isHidden = model.name == .all

        mandatoryLabel.isHidden = true
        regexOptional(model: model)
        checkView.image = model.isSelected ? UIImage(named: "ico_selected") : UIImage(named: "ico_not_selected")
    }
    
    func regexOptional(model: Terms) {
        let regex = "\\((.*?)\\)"
        let textOptional = model.name.title.matchesForRegexInText(regex: regex, text: model.name.title)
        let range = (model.name.title as NSString).range(of: textOptional ?? "")
        let mutableAttributedString = NSMutableAttributedString.init(string: model.name.title)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                             value: UIColor(hexString: "#7B7B7B"), range: range)
        nameLabel.attributedText = mutableAttributedString
    }
}
