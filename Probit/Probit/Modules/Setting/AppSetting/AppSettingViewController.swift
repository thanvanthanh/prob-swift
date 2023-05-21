//
//  AppSettingViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 30/08/2022.
//  
//

import UIKit

class AppSettingViewController: BaseViewController {
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageHintLabel: UILabel!
    @IBOutlet weak var languageSelectedLabel: UILabel!
    @IBOutlet weak var tickerColorLabel: UILabel!
    @IBOutlet weak var buyLabel: UILabel!
    @IBOutlet weak var buyIcon: UIImageView!
    @IBOutlet weak var sellIcon: UIImageView!
    @IBOutlet weak var sellLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var appLockLabel: UILabel!
    @IBOutlet weak var termsAndPoliciesLabel: UILabel!
    @IBOutlet weak var appInfoLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var deleteAccountLabel: UILabel!
    
    @IBOutlet weak var languageView: HighlightView!
    @IBOutlet weak var tikerColorView: HighlightView!
    @IBOutlet weak var notificationView: HighlightView!
    @IBOutlet weak var appLockView: HighlightView!
    @IBOutlet weak var termView: HighlightView!
    @IBOutlet weak var appInfoView: HighlightView!
    @IBOutlet weak var deleteAccountView: HighlightView!
    
    @IBOutlet weak var languageImageView: UIImageView!
    @IBOutlet weak var colorTickerImageView: UIImageView!
    @IBOutlet weak var notificationImageView: UIImageView!
    @IBOutlet weak var appLockImageView: UIImageView!
    @IBOutlet weak var termsImageView: UIImageView!
    @IBOutlet weak var appInfoImageView: UIImageView!
    @IBOutlet weak var deleteAccountImageView: UIImageView!
    
    // MARK: - Properties
    var presenter: ViewToPresenterAppSettingProtocol?
        
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigationBar(title: "activity_appsettings_title".Localizable(),
                                titleLeftItem: "navigationbar_settings".Localizable())
        [notificationView, appLockView, deleteAccountView].forEach { $0?.isHidden = !AppConstant.isLogin}
        upDateTickerColor(options: AppConstant.tickerColor)
        addGestureLongPress()
    }
    
    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        languageSelectedLabel.textAlignment = isRTL ? .left : .right
    }
    
    func addGestureLongPress() {
        deleteAccountView.applyMoreStyle()
        deleteAccountView.delegate = self
        deleteAccountView.addTapGesture { [weak self] in
            guard let `self` = self else { return }
            self.presenter?.navigateToProBitWebsite(viewController: self)
        }
        termView.applyMoreStyle()
        termView.delegate = self
        termView.addTapGesture { [weak self] in
            guard let `self` = self else { return }
            self.presenter?.navigateToTermsAndPolicies()
        }
        appInfoView.applyMoreStyle()
        appInfoView.delegate = self
        appInfoView.addTapGesture { [weak self] in
            guard let `self` = self else { return }
            self.presenter?.navigateToAppInfo()
        }
        appLockView.applyMoreStyle()
        appLockView.delegate = self
        appLockView.addTapGesture { [weak self] in
            guard let `self` = self else { return }
            self.presenter?.navigateToAppLock()
        }
        notificationView.applyMoreStyle()
        notificationView.delegate = self
        notificationView.addTapGesture { [weak self] in
            guard let `self` = self else { return }
            self.presenter?.navigateToNotifications()
        }
        tikerColorView.applyMoreStyle()
        tikerColorView.delegate = self
        tikerColorView.addTapGesture { [weak self] in
            guard let `self` = self else { return }
            self.presenter?.navigateToTickerColor(delegate: self)
        }
        languageView.applyMoreStyle()
        languageView.delegate = self
        languageView.addTapGesture { [weak self] in
            guard let `self` = self else { return }
            self.presenter?.navigateToAppSettingLanguage()
        }
    }
    
    override func localizedString() {
        languageLabel.text = "settings_app_language".Localizable()
        languageHintLabel.text = "activity_appsettings_language_hint".Localizable()
        let name = Locale(identifier: AppConstant.localeId).localizedString(forLanguageCode: AppConstant.localeId)
        languageSelectedLabel.text = name
        tickerColorLabel.text = "activity_appsettings_v2_tickercolour".Localizable()
        buyLabel.text = "common_buy".Localizable()
        sellLabel.text = "sell_noformat".Localizable()
        notificationLabel.text = "fragment_settings_notifications".Localizable()
        appLockLabel.text = "activity_security_v2_titlebar".Localizable()
        termsAndPoliciesLabel.text = "fragment_settings_terms".Localizable()
        appInfoLabel.text = "activity_appinfo_title".Localizable()
        deleteAccountLabel.text = "appsetting_delete_account".Localizable()
        appVersionLabel.text = AppConstant.appVersion
    }
    
    private func upDateTickerColor(options: TickerColor) {
        buyIcon.image = UIImage(named: options.imageBuy)
        sellIcon.image = UIImage(named: options.imageSell)
    }
}

extension AppSettingViewController: PresenterToViewAppSettingProtocol {
    // TODO: Implement View Output Methods
    func reloadCurrencyData(option: TickerColor) {
        upDateTickerColor(options: option)
    }
}

extension AppSettingViewController: TickerColorDelegate {
    func getTickerColor(options: TickerColor) {
        self.presenter?.updateData(option: options)
    }
}

extension AppSettingViewController: HighlightViewProtocol {
    func highlight(view: HighlightView) {
        switch view {
        case languageView:
            languageLabel.textColor = UIColor.color_4231c8_6f6ff7
            languageImageView.setTintImageView(imageName: "ico_language",
                                               colorTint: UIColor.color_4231c8_6f6ff7)
        case tikerColorView:
            tickerColorLabel.textColor = UIColor.color_4231c8_6f6ff7
            colorTickerImageView.setTintImageView(imageName: "ico_colorfilter",
                                                  colorTint: UIColor.color_4231c8_6f6ff7)
        case notificationView:
            notificationLabel.textColor = UIColor.color_4231c8_6f6ff7
            notificationImageView.setTintImageView(imageName: "ico_setting_notification",
                                                   colorTint: UIColor.color_4231c8_6f6ff7)
        case appLockView:
            appLockLabel.textColor = UIColor.color_4231c8_6f6ff7
            appLockImageView.setTintImageView(imageName: "ico_lock",
                                              colorTint: UIColor.color_4231c8_6f6ff7)
        case termView:
            termsAndPoliciesLabel.textColor = UIColor.color_4231c8_6f6ff7
            termsImageView.setTintImageView(imageName: "ico_file",
                                            colorTint: UIColor.color_4231c8_6f6ff7)
        case appInfoView:
            appInfoLabel.textColor = UIColor.color_4231c8_6f6ff7
            appInfoImageView.setTintImageView(imageName: "ico_setting_app_infor",
                                              colorTint: UIColor.color_4231c8_6f6ff7)
        case deleteAccountView:
            deleteAccountLabel.textColor = UIColor.color_4231c8_6f6ff7
            deleteAccountImageView.setTintImageView(imageName: "ico_setting_trash",
                                                    colorTint: UIColor.color_4231c8_6f6ff7)
        default: break
        }
    }
    
    func unHighlight(view: HighlightView) {
        switch view {
        case languageView:
            languageLabel.textColor = UIColor.color_424242_fafafa
            languageImageView.image = UIImage(named: "ico_language")
        case tikerColorView:
            tickerColorLabel.textColor = UIColor.color_424242_fafafa
            colorTickerImageView.image = UIImage(named: "ico_colorfilter")
        case notificationView:
            notificationLabel.textColor = UIColor.color_424242_fafafa
            notificationImageView.image = UIImage(named: "ico_setting_notification")
        case appLockView:
            appLockLabel.textColor = UIColor.color_424242_fafafa
            appLockImageView.image = UIImage(named: "ico_lock")
        case termView:
            termsAndPoliciesLabel.textColor = UIColor.color_424242_fafafa
            termsImageView.image = UIImage(named: "ico_file")
        case appInfoView:
            appInfoLabel.textColor = UIColor.color_424242_fafafa
            appInfoImageView.image = UIImage(named: "ico_setting_app_infor")
        case deleteAccountView:
            deleteAccountLabel.textColor = UIColor.color_424242_fafafa
            deleteAccountImageView.image = UIImage(named: "ico_setting_trash")
        default: break
        }
    }
}

extension HighlightView {
    func applyMoreStyle() {
        bgColor = .color_fafafa_181818
        highlightType = .normal
    }
}
