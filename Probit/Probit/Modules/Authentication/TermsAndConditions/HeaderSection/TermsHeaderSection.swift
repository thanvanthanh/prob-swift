//
//  TermsHeaderSection.swift
//  Probit
//
//  Created by Nguyen Quang on 22/08/2022.
//

import UIKit

class TermsHeaderSection: BaseView {
    @IBOutlet weak var viewMore: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var viewMoreButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mandatoryLabel: UILabel!
    @IBOutlet weak var checkView: UIImageView!
    @IBOutlet weak var handlerButton: UIButton!
    @IBOutlet weak var optionalLabel: UILabel!
    
    func binding(model: Terms) {
        lineView.isHidden = model.name != .all
        viewMore.isHidden = model.name == .all
        mandatoryLabel.isHidden = !model.isMandatory
        optionalLabel.isHidden = !model.isMandatory
        mandatoryLabel.text = "smallagreementelementinterface_mandatory".Localizable()
        checkView.image = model.isSelected ? UIImage(named: "ico_selected") : UIImage(named: "ico_not_selected")
        nameLabel.textAlignment = AppConstant.isLanguageRightToLeft ? .right : .left
        mandatoryLabel.textAlignment = AppConstant.isLanguageRightToLeft ? .right : .left
        optionalLabel.textAlignment = AppConstant.isLanguageRightToLeft ? .right : .left
        guard model.isMandatory else {
            regexOptional(model: model)
            return
        }
        nameLabel.text = model.name.title
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
