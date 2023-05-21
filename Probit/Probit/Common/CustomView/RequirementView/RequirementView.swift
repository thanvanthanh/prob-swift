//
//  RequirementView.swift
//  Probit
//
//  Created by Nguyen Quang on 23/09/2022.
//

import UIKit

protocol RequirementViewDelegate {
    func goToStake()
    func goToKyc()
}

class RequirementView: BaseView {
    
    @IBOutlet weak var goStakeContainer: UIStackView!
    @IBOutlet weak var goStakeLabel: UILabel!
    @IBOutlet weak var checkedView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var boosterView: UIImageView!
    
    var delegate: RequirementViewDelegate?
    
    init(value: String, title: String) {
        super.init()
        setupNormalView(value: value, title: title)
    }
    
    init(valueUnderline: String, title: String) {
        super.init()
        setupLoginRequiredView(value: valueUnderline, title: title)
    }
    
    init(eligibilityValue: String, title: String, isEligibility: Bool = false) {
        super.init()
        setupEligibilityView(eligibilityValue: eligibilityValue, title: title, isEligibility: isEligibility)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNormalView(value: String, title: String) {
        boosterView.isHidden = true
        checkedView.isHidden = true
        goStakeContainer.isHidden = true
        
        titleLabel.text = title
        valueLabel.text = value
        valueLabel.textAlignment = AppConstant.isLanguageRightToLeft ? .left : .right
        valueLabel.textColor = UIColor.color_282828_fafafa
    }
    
    func setupLoginRequiredView(value: String, title: String) {
        boosterView.isHidden = true
        checkedView.isHidden = true
        goStakeContainer.isHidden = true
        
        titleLabel.text = title
        valueLabel.text = value
        valueLabel.textAlignment = AppConstant.isLanguageRightToLeft ? .left : .right
        valueLabel.textColor = UIColor.color_4231c8_6f6ff7
        valueLabel.underline()
    }
    
    func setupEligibilityView(eligibilityValue: String, title: String, isEligibility: Bool = false) {
        
        valueLabel.isHidden = true
        checkedView.isHidden = true
        boosterView.isHidden = true
        goStakeContainer.isHidden = true
        titleLabel.text = title
        
        guard isEligibility else {
            goStakeContainer.isHidden = false
            goStakeLabel.text = eligibilityValue
            goStakeLabel.textColor = UIColor.color_4231c8_6f6ff7
            goStakeLabel.underline()
            if eligibilityValue == "tradecompetition_main_requirement_probstake_eligibility_gostake".Localizable() {
                goStakeContainer.addTapGesture { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.goToStake()
                }
            } else {
                goStakeContainer.addTapGesture { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.goToKyc()
                }
            }
            return
        }
        checkedView.isHidden = false
        checkedView.image = UIImage(named: "ico_checked_trading")?.withRenderingMode(.alwaysTemplate)
        checkedView.tintColor = UIColor.Basic.blue
        
    }
    
    func displayBoosterView(isSelected: Bool) {
        boosterView.isHidden = isSelected
        checkedView.isHidden = true
        goStakeContainer.isHidden = true
        boosterView.tintColor = UIColor.Basic.mainText
        boosterView.image = UIImage(named: "ico_booster")?.withRenderingMode(.alwaysTemplate)
    }
}
