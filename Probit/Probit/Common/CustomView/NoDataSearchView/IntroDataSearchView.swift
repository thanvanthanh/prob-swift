//
//  IntroDataSearchView.swift
//  Probit
//
//  Created by Le Duc Giap on 05/12/2022.
//

import Foundation
import UIKit

class IntroDataSearchView: BaseView {
    @IBOutlet weak var searchIntroLabel: UILabel!
    @IBOutlet weak var searchMessageLabel: UILabel!
    
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var introSearchView: UIStackView!
    @IBOutlet weak var noDataSearchView: UIStackView!
    @IBOutlet weak var layoutSpaceWhenShowKeyboard: NSLayoutConstraint!
    
    override func localizedString() {
        super.localizedString()
        searchIntroLabel.text = "activity_search_searchbackdrop_title".Localizable()
        searchMessageLabel.text = "activity_search_searchbackdrop_content".Localizable()
        noResultLabel.text = "activity_search_noresult".Localizable()
    }
    
    func resetLayoutWhenShowKeyboard(height: CGFloat) {
        layoutSpaceWhenShowKeyboard.constant = height/2
    }
    
}
