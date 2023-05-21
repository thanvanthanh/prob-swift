//
//  SettingView.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/10/2022.
//

import UIKit

protocol SettingViewDelegate: AnyObject {
    func appSettingViewNormalTap()
    func announcementViewNormalTap()
    func homePageViewNormalTap()
}

@IBDesignable class SettingView: BaseView {
    @IBOutlet private weak var appSettingLabel: UILabel!
    @IBOutlet private weak var announcementsLabel: UILabel!
    @IBOutlet private weak var homePageLabel: UILabel!
    @IBOutlet private weak var topLineView: UIView!
    
    @IBOutlet weak var appSettingView: HighlightView!
    @IBOutlet weak var announcementView: HighlightView!
    @IBOutlet weak var homePageView: HighlightView!
    
    @IBOutlet weak var settingImageView: UIImageView!
    @IBOutlet weak var announcementImageView: UIImageView!
    @IBOutlet weak var homePageImageView: UIImageView!
    
    weak var delegate: SettingViewDelegate?
    
    override func localizedString() {
        appSettingLabel.text = "fragment_settings_appsettings".Localizable()
        announcementsLabel.text = "fragment_settings_announcements".Localizable()
        homePageLabel.text = "www.probit.com"
        homePageLabel.underline()
    }
    
    override func setupUI() {
        appSettingView.applyMoreStyle()
        appSettingView.delegate = self
        appSettingView.addTapGesture { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.appSettingViewNormalTap()
        }
        
        announcementView.applyMoreStyle()
        announcementView.delegate = self
        announcementView.addTapGesture { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.announcementViewNormalTap()
        }
        
        homePageView.applyMoreStyle()
        homePageView.delegate = self
        homePageView.addTapGesture { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.homePageViewNormalTap()
        }
    }
    
    func reloadView() {
        topLineView.isHidden = AppConstant.isLogin == false
    }
    
}

extension SettingView: HighlightViewProtocol {
    func highlight(view: HighlightView) {
        switch view {
        case appSettingView:
            appSettingLabel.textColor = UIColor.color_4231c8_6f6ff7
            settingImageView.setTintImageView(imageName: "ico_setting2",
                                              colorTint: UIColor.color_4231c8_6f6ff7)
        case announcementView:
            announcementsLabel.textColor = UIColor.color_4231c8_6f6ff7
            announcementImageView.setTintImageView(imageName: "ico_setting_notification",
                                                   colorTint: UIColor.color_4231c8_6f6ff7)
        case homePageView:
            homePageLabel.textColor = UIColor.color_4231c8_6f6ff7
            homePageImageView.setTintImageView(imageName: "ico_setting_home",
                                               colorTint: UIColor.color_4231c8_6f6ff7)
        default: break
        }
    }
    
    func unHighlight(view: HighlightView) {

        switch view {
        case appSettingView:
            appSettingLabel.textColor = UIColor.color_424242_fafafa
            settingImageView.image = UIImage(named: "ico_setting2")
        case announcementView:
            announcementsLabel.textColor = UIColor.color_424242_fafafa
            announcementImageView.image = UIImage(named: "ico_setting_notification")
        case homePageView:
            homePageLabel.textColor = UIColor.color_424242_fafafa
            homePageImageView.image = UIImage(named: "ico_setting_home")
        default: break
        }
    }
}
