//
//  SettingView.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/10/2022.
//

import UIKit

@IBDesignable class SettingView: BaseView {
    @IBOutlet private weak var appSettingLabel: UILabel!
    @IBOutlet private weak var appSettingButton: UIButton!
    @IBOutlet private weak var announcementsLabel: UILabel!
    @IBOutlet private weak var announcementsButton: UIButton!
    @IBOutlet private weak var homePageLabel: UILabel!
    @IBOutlet private weak var homePageButton: UIButton!
    
    override func localizedString() {
        appSettingLabel.text = "fragment_settings_appsettings".Localizable()
        announcementsLabel.text = "fragment_settings_announcements".Localizable()
        homePageLabel.text = "www.probit.com"
        homePageLabel.underline()
    }
    
    func getAction(appSetting: @escaping Action,
                   announcements: @escaping Action,
                   homePage: @escaping Action) {
        appSettingButton.did(.touchUpInside) { _, _ in
            appSetting()
        }
        announcementsButton.did(.touchUpInside) { _, _ in
            announcements()
        }
        homePageButton.did(.touchUpInside) { _, _ in
            homePage()
        }
    }
}
