//
//  NewCoinSection.swift
//  Probit
//
//  Created by Nguyen Quang on 10/09/2022.
//

import UIKit

class NewCoinSection: BaseView {

    @IBOutlet weak var newcoinsLabel: UILabel!
    
    override func localizedString() {
        super.localizedString()
        newcoinsLabel.text = "customview_newcoin_title".Localizable()
    }
}
