//
//  ReferralViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 29/08/2022.
//  
//

import UIKit

class ReferralViewController: BaseViewController {
    
    @IBOutlet weak var referralTitle: UILabel!
    @IBOutlet weak var referralContent: UILabel!
    @IBOutlet weak var urlView: UIView!
    
    @IBOutlet private weak var commissionContainerView: UIView!
    @IBOutlet weak var commissionLabel: UILabel!
    @IBOutlet weak var commissionCountLabel: UILabel!
    
    @IBOutlet weak var referTitle: UILabel!
    @IBOutlet weak var referCount: UILabel!
    
    @IBOutlet private weak var referralBonusContainerView: UIView!
    @IBOutlet weak var referBonusLabel: UILabel!
    @IBOutlet weak var urlAccount: UILabel!
    
    @IBOutlet weak var referralStackView: UIStackView!
    @IBOutlet weak var coppyButton: StyleButton!
    // MARK: - Properties
    var presenter: ViewToPresenterReferralProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.getData()
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigationBar(title: "v2icon_home_referral".Localizable(),
                                titleLeftItem: "common_previous".Localizable())
    }
    
    override func localizedString() {
        referralTitle.text = "activity_referralshare_title".Localizable()
        referralContent.text = "activity_referralshare_content".Localizable()
        commissionLabel.text = "activity_referralshare_v2_commisionfee_title".Localizable().removing(charactersOf: "(%@)")
        referTitle.text = "customview_userinfo_refer_title".Localizable()
        referBonusLabel.text = "activity_referralshare_v2_earnedamount_container_title".Localizable()
        coppyButton.setTitle("activity_referralshare_v2_copyurl".Localizable(), for: .normal)
    }
    
    private func setupDataWhenCallingApi() {
        guard let referrerCount = presenter?.referrerCount,
              let referrerCode = presenter?.referrerCode,
              let commissionFee = presenter?.commissionFee else { return }
        referCount.text = referrerCount
        urlAccount.text =  referrerCode
        commissionCountLabel.text = commissionFee
    }
    
    private func setupStackView(model: [ReferrerEarnedModel]) {
        referralStackView.removeFullyAllArrangedSubviews()
        model.forEach { referral in
            let view = ReferralTokenView()
            view.setupStack(model: referral)
            referralStackView.addArrangedSubview(view)
            
            NSLayoutConstraint.activate([
                view.heightAnchor.constraint(equalToConstant: 35)
            ])
        }
        let spacingView = UIView()
        spacingView.backgroundColor = .clear
        referralStackView.addArrangedSubview(spacingView)
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        urlView.borderColor = UIColor.color_e6e6e6_424242
        commissionContainerView.borderColor = UIColor(named: "color_d9d6f4_6f6ff7_30")
        referralBonusContainerView.borderColor = UIColor(named: "color_d9d6f4_6f6ff7_30")
    }
    
    // MARK: - Actions
    @IBAction func coppyUrlAction(_ sender: Any) {
        UIPasteboard.general.string = urlAccount.text
        showFloatsMessage(title: "copy_to_clipboard_toast".Localizable(), type: .success)
    }
    
    @IBAction func facebookShareAction(_ sender: Any) {
        ShareHelper.shared.shareToFacebook(link: presenter?.referrerCode ?? "")
    }
    
    @IBAction func instagramShareAction(_ sender: Any) {
        ShareHelper.shared.shareToInstagram(link: presenter?.referrerCode ?? "")
    }
    
    @IBAction func linkedinShareAction(_ sender: Any) {
        ShareHelper.shared.shareToLinkedin(link: presenter?.referrerCode ?? "")
    }
    
    @IBAction func telegramShareAction(_ sender: Any) {
        ShareHelper.shared.shareToTelegram(link: presenter?.referrerCode ?? "")
    }
    
    @IBAction func moreShareAction(_ sender: Any) {
        ShareHelper.shared.shareMore(message: presenter?.referrerCode ?? "",
                                     link: presenter?.referrerCode ?? "")
    }
    
}

extension ReferralViewController: PresenterToViewReferralProtocol {
    // TODO: Implement View Output Methods
    func callingApiComplete() {
        hideLoading()
        setupDataWhenCallingApi()
        let listData = presenter?.referrerEarned ?? []
        setupStackView(model: listData)
    }
    
    func loadApiError() {
        hideLoading()
        showFloatsMessage(message: "network_connection_unstable_warning".Localizable(),
                          type: .error)
    }
}
