//
//  NoDataSearchView.swift
//  Probit
//
//  Created by Nguyen Quang on 17/10/2022.
//

import Foundation
import UIKit

class NoDataSearchView: BaseView {
    @IBOutlet weak var searchTitleLabel: UILabel!
    @IBOutlet weak var searchContentLabel: UILabel!
    
    override func localizedString() {
        super.localizedString()
        searchTitleLabel.text = "activity_search_noresult".Localizable()
        searchContentLabel.text = "activity_search_searchbackdrop_content".Localizable()
    }
}
