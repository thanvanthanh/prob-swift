//
//  WithdrawStepView.swift
//  Probit
//
//  Created by Dang Nguyen on 01/11/2022.
//

import UIKit

enum WithdrawStep: Int {
    case amount = 1
    case address = 2
    case review = 3
}

@IBDesignable class WithdrawStepView: BaseView {

    @IBOutlet weak var step2LineView: UIView!
    @IBOutlet weak var step1LineView: UIView!
    @IBOutlet weak var step3Label: UILabel!
    @IBOutlet weak var reviewDetailLabel: UILabel!
    @IBOutlet weak var step2Label: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var step1Label: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    @IBInspectable
    var withdrawStep: Int = WithdrawStep.amount.rawValue {
        didSet {
            updateStep()
        }
    }
    
    override func awakeFromNib() {
        amountLabel.text = "activity_withdrawal_textindicator1".Localizable()
        addressLabel.text = "activity_withdrawal_textindicator2".Localizable()
        reviewDetailLabel.text = "activity_withdrawal_textindicator3".Localizable()
    }
    
    func updateStep() {
        let normalColor = UIColor.color_b6b6b6_7b7b7b
        let highLightColor = UIColor.color_4231c8_6f6ff7
        switch withdrawStep {
            case WithdrawStep.address.rawValue:
                step1Label.borderColor = highLightColor
                step1Label.textColor = highLightColor
                amountLabel.textColor = highLightColor
                step1LineView.backgroundColor = highLightColor
                step2Label.borderColor = highLightColor
                step2Label.textColor = highLightColor
                addressLabel.textColor = highLightColor
                step2LineView.backgroundColor = normalColor
                step3Label.borderColor = normalColor
                step3Label.textColor = normalColor
                reviewDetailLabel.textColor = normalColor
            case WithdrawStep.review.rawValue:
                step1Label.borderColor = highLightColor
                step1Label.textColor = highLightColor
                amountLabel.textColor = highLightColor
                step2Label.borderColor = highLightColor
                step2Label.textColor = highLightColor
                addressLabel.textColor = highLightColor
                step3Label.borderColor = highLightColor
                step3Label.textColor = highLightColor
                reviewDetailLabel.textColor = highLightColor
                step2LineView.backgroundColor = highLightColor

        default:
            step1Label.borderColor = highLightColor
            step1Label.textColor = highLightColor
            amountLabel.textColor = highLightColor
            step2Label.borderColor = normalColor
            step2Label.textColor = normalColor
            addressLabel.textColor = normalColor
            step3Label.borderColor = normalColor
            step3Label.textColor = normalColor
            reviewDetailLabel.textColor = normalColor
            step1LineView.backgroundColor = normalColor
            step2LineView.backgroundColor = normalColor
        }
    }
}
