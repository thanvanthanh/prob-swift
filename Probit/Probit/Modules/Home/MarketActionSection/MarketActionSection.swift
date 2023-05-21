//
//  MarketActionSection.swift
//  Probit
//
//  Created by Nguyen Quang on 10/09/2022.
//

import UIKit
 
protocol MarketActionSectionDelegate {
    func goToExchage ()
}
class MarketActionSection: BaseView {
    var delegate: MarketActionSectionDelegate?
    @IBOutlet weak var viewMarketButton: StyleButton!
    override func localizedString() {
        super.localizedString()
        viewMarketButton.setTitle("customview_marketlist_button_text".Localizable(), for: .normal)
    }
    
    @IBAction func goToExchange(_ sender: Any) {
        delegate?.goToExchage()
    }
}
