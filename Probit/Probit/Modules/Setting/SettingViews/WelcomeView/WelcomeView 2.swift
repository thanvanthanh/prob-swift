//
//  WelcomeView.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/10/2022.
//

import UIKit

@IBDesignable class WelcomeView: BaseView {

    @IBOutlet private weak var welcomeLabel: UILabel!
    @IBOutlet private weak var requireLabel: UILabel!
    var action: Action = {}
    
    override func localizedString() {
        welcomeLabel.text = "fragment_settings_v2_welcome".Localizable()
        requireLabel.text = "fragment_settings_pleaselogin".Localizable()
        requireLabel.underline()
    }
    
    override func setupUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(WelcomeView.tapFunction))
        requireLabel.isUserInteractionEnabled = true
        requireLabel.addGestureRecognizer(tap)
    }
    
    @objc
    func tapFunction(sender: UITapGestureRecognizer) {
        self.action()
    }
}
