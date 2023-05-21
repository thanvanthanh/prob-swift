//
//  SettingViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 29/08/2022.
//  
//

import UIKit

class SettingViewController: BaseViewController {
    @IBOutlet private weak var welcomeView: WelcomeView!
    @IBOutlet private weak var accountView: AccountView!
    @IBOutlet private weak var buyProbitView: BuyProbitBanner!
    @IBOutlet private weak var feesView: FeesView!
    @IBOutlet private weak var settingView: SettingView!
    @IBOutlet private weak var loginButton: ButtonSetting!
    @IBOutlet var spacingView: [UIView]!
    
    // MARK: - Properties
    var presenter: ViewToPresenterSettingProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadUI()
    }
    
    private func loadingDataChangeAccount() {
        guard accountView.getCurrentEmail() != AppConstant.profileInfo?.email else { return }
        accountView.showLoadingUI()
    }
    
    private func reloadUI() {
        setupUISetting()
        loginButton.setupButton()
        guard AppConstant.isLogin else { return }
        loadingDataChangeAccount()
        accountView.setupView()
        presenter?.getData()
        presenter?.getProfile()
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigationBar(title: "navigationbar_settings".Localizable(),
                                titleLeftItem: nil)
        setupAction()
        accountView.delegate = self
    }
    
    private func setupUISetting() {
        spacingView.forEach { $0.isHidden = !AppConstant.isLogin }
        [welcomeView].forEach({ $0?.isHidden = AppConstant.isLogin })
        [accountView, feesView].forEach({ $0?.isHidden = !AppConstant.isLogin })
        settingView.reloadView()
        settingView.delegate = self
    }
    
    private func setupDataWhenCallingApi() {
        if let profileInfo = presenter?.profileInfo {
            accountView.setupView(profile: profileInfo)
        }
        if let membership = presenter?.membershipData, let referrerCount = presenter?.referrerCount {
            accountView.setupView(membership: membership, referrerCount: referrerCount)
        }
        if let iconColor = presenter?.iconColor,
           let kycWaring = presenter?.kycWarning,
           let kycButtonTitle = presenter?.kycButtonTitle {
            accountView.setupView(iconColor: iconColor,
                                  kycWaring: kycWaring, kycButtonTitle: kycButtonTitle)
        }
        if let kycStatusData = presenter?.userKycStatus?.data {
            accountView.setupView(kycStatusData: kycStatusData)

        }
        guard let feesDiscount = presenter?.feesDiscount,
              let payInProb = presenter?.getPayInProbData?.payInProb else { return }
        feesView.setupView(payInProb: payInProb,
                           feesDiscount: feesDiscount,
                           hasProb: presenter?.hasProbToken ?? false)
    }
    
    // MARK: - Actions
    @objc
    func loginComplete(notfication: NSNotification) {
        presenter?.navigateToHome()
    }
    
    private func setupAction() {
        welcomeView.action = { [weak self] in
            guard let self = self else { return }
            self.presenter?.navigateToLogin()
        }
        
        accountView.getAction(friendInvited: { [weak self] in
            guard let self = self else { return }
            self.presenter?.navigateToReferral()
        }, membership: { [weak self] in
            guard let self = self else { return }
            self.presenter?.navigateToMembership()
        })
        
        buyProbitView.getAction { [weak self] in
            guard let self = self else { return }
            self.presenter?.navigateToPurchase()
        }
        
        feesView.getAction { [weak self] isOn in
            guard let self = self else { return }
            self.presenter?.postPayInProb(param: isOn)
        }
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        AppConstant.isLogin ? handleLogoutAction() : handleLoginAction()
    }
    
    private func handleLoginAction() {
        presenter?.navigateToLogin()
    }
    
    private func handleLogoutAction() {
        showPopupHelper("dialog_before_logout_title".Localizable(),
                        message: "dialog_before_logout_tips".Localizable(),
                        warning: nil,
                        acceptTitle: "dialog_logout".Localizable(),
                        cancleTitle: "dialog_cancel".Localizable(),
                        acceptAction: { [weak self] in
            guard let self = self else { return }
            AppConstant.logout()
            self.presenter?.navigateToHome()
        }, cancelAction: nil)
    }
    
}

extension SettingViewController: PresenterToViewSettingProtocol{
    // TODO: Implement View Output Methods
    func callingApiComplete() {
        setupDataWhenCallingApi()
    }
    
    func loadApiError() {
        showFloatsMessage(title: "network_connection_unstable_warning".Localizable(),
                          type: .error)
    }
    
    func postFeesSwitchComplete(msg: String) {
        print(msg)
    }
}

// MARK: - SettingAccountViewDelegate
extension SettingViewController: SettingAccountViewDelegate {
    func settingAccountViewVerifyKycLabelTap() {
        presenter?.navigateToVerifyKyc()
    }
}

// MARK: - SettingViewDelegate
extension SettingViewController: SettingViewDelegate {
    func appSettingViewNormalTap() {
        self.presenter?.navigateToAppSetting()
    }
    
    func announcementViewNormalTap() {
        self.presenter?.navigateToAnnouncements(viewcontroller: self)
    }
    
    func homePageViewNormalTap() {
        self.presenter?.navigateToHomePage(viewcontroller: self)
    }
    
}
