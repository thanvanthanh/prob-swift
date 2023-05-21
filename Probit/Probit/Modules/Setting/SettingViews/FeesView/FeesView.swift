//
//  FeesView.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/10/2022.
//

import UIKit

@IBDesignable class FeesView: BaseView {
    @IBOutlet private weak var feesSwitch: UISwitch!
    @IBOutlet private weak var feesLabel: UILabel!
    @IBOutlet private weak var feesWarningLabel: UILabel!

    private var payInProb: String? = ""
    private var feesDiscount: String? = ""
    
    var sender: Bool = false
    
    private var hashProb: Bool = false
    
    override func setupUI() {
        sender = payInProb == "on" ? true : false
        feesSwitch.isOn = sender
        updateUIWhenChangeSwitch()
        feesLabel.text = "fragment_settings_v2_tradefeewithprob_switch_title".Localizable()
    }
    
    func setupView(payInProb: String, feesDiscount: String, hasProb: Bool) {
        feesSwitch.semanticContentAttribute = .forceLeftToRight
        self.payInProb = payInProb
        self.feesDiscount = feesDiscount
        sender = payInProb == "on" ? true : false
        self.hashProb = hasProb
        updateUIWhenChangeSwitch()
    }
    
    private func updateUIWhenChangeSwitch() {
        let feesColor = hashProb ? UIColor(hexString: "#7B7B7B")
        : sender ? UIColor(hexString: "#F25D4E") : UIColor(hexString: "#7B7B7B")
        feesWarningLabel.textColor = feesColor
        feesSwitch.isOn = sender
        let feesOn = "fragment_settings_v2_tradefeewithprob_switch_hint_noprob_problem".Localizable()
        let feesOff = String.init(format: "fragment_settings_v2_tradefeewithprob_switch_hint".Localizable(),
                                  "\(feesDiscount ?? "")")
        feesWarningLabel.text = hashProb ? feesOff : sender ? feesOn : feesOff
    }
    
    func getAction(fees: @escaping (Bool) -> Void){
        feesSwitch.did(.valueChanged) { _, value in
            guard let isOn = value as? Bool else { return }
            fees(isOn)
            self.sender = isOn
            self.updateUIWhenChangeSwitch()
        }
    }
    
}
