//
//  AccountView.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/10/2022.
//

import UIKit

protocol SettingAccountViewDelegate: AnyObject {
    func settingAccountViewVerifyKycLabelTap()
}

@IBDesignable class AccountView: BaseView {
    
    @IBOutlet private weak var completeKycView: UIView!
    @IBOutlet private weak var accountLabel: UILabel!
    @IBOutlet private weak var idAccountLabel: UILabel!
    @IBOutlet private weak var phoneNumberLabel: UILabel!
    @IBOutlet private weak var eyeAccountImage: UIImageView!
    @IBOutlet private weak var friendInvitedButton: UIButton!
    @IBOutlet private weak var membershipButton: UIButton!
    @IBOutlet private weak var membershipIcon: UIImageView!
    @IBOutlet private weak var memberShipLevel: UILabel!
    @IBOutlet private weak var countInvitedLabel: UILabel!
    @IBOutlet private weak var invitedLabel: UILabel!
    // KYC
    @IBOutlet private weak var kycIcons: UIImageView!
    @IBOutlet private weak var kycLabel: UILabel!
    @IBOutlet private weak var verifyKycLabel: UILabel!
    @IBOutlet private weak var kycWarningView: UIView!
    @IBOutlet private weak var kycReasonsLabel: UILabel!
    @IBOutlet private weak var kycRejectMessageStack: UIStackView!
    
    // MARK: - Private Variable
    private var isShowId: Bool = false
    
    // MARK: - Public Variable
    weak var delegate: SettingAccountViewDelegate?
    
    func setupView() {
        isShowId = false
        let tapEye = UITapGestureRecognizer(target: self, action: #selector(AccountView.eyeTapped))
        eyeAccountImage.image = UIImage(named: "ico_eye_hide")
        eyeAccountImage.isUserInteractionEnabled = true
        eyeAccountImage.addGestureRecognizer(tapEye)
        
        let tapVerfiyKyc = UITapGestureRecognizer(target: self, action: #selector(verifyKycTapped))
        verifyKycLabel.isUserInteractionEnabled = true
        verifyKycLabel.addGestureRecognizer(tapVerfiyKyc)
    }
    
    override func localizedString() {
        invitedLabel.text = "customview_userinfo_refer_title".Localizable()
        kycReasonsLabel.text = "globalkyc_infopanel_rejectedreason".Localizable()
    }
    
    func getAction(friendInvited: @escaping Action,
                   membership: @escaping Action) {
        friendInvitedButton.did(.touchUpInside) { _, _ in
            friendInvited()
        }
        membershipButton.did(.touchUpInside) { _, _ in
            membership()
        }
    }
    
    // Setup View
    func setupView(profile: ProfileInfo?,
                   membership: MembershipModel,
                   referrerCount: String,
                   iconColor: UIColor,
                   kycStatusData: UserKycStatusDetailModel,
                   kycWaring: String,
                   kycButtonTitle: String) {
        accountLabel.text = profile?.email
        idAccountLabel.text = profile?.uid.isSecureText()
        memberShipLevel.text = membership.data.membershipType?.title
        membershipIcon.image = UIImage(named: membership.data.membershipType?.icon ?? "")
        countInvitedLabel.text = referrerCount
        
        kycWarningView.isHidden = !(kycStatusData.statusType == .rejected)
        setupKycRejectStack(data: kycStatusData.rejectCodeArray)
        
        kycIcons.tintColor = iconColor
        kycLabel.text = kycWaring
        verifyKycLabel.text = kycButtonTitle
        verifyKycLabel.underline()
    }
    
    public func showLoadingUI() {
        setupView(profile: nil)
        setupView(membership: nil, referrerCount: nil)
        setupView(iconColor: nil, kycWaring: nil, kycButtonTitle: nil)
        setupView(kycStatusData: nil)
    }
    
    func setupView(iconColor: UIColor?,
                   kycWaring: String?,
                   kycButtonTitle: String?) {
        guard let iconColor = iconColor,
              let kycWaring = kycWaring,
              let kycButtonTitle = kycButtonTitle else {
                  completeKycView.isHidden = true
                  return
        }
        completeKycView.isHidden = false
        kycIcons.tintColor = iconColor
        kycLabel.text = kycWaring
        verifyKycLabel.text = kycButtonTitle
        verifyKycLabel.underline()
    }
    
    func setupView(kycStatusData: UserKycStatusDetailModel?) {
        guard let kycStatusData = kycStatusData else {
            self.kycWarningView.isHidden = true
            return
        }
        kycWarningView.isHidden = !(kycStatusData.statusType == .rejected)
        setupKycRejectStack(data: kycStatusData.rejectCodeArray)
    }
    
    func setupView(membership: MembershipModel?,
                   referrerCount: String?) {
        memberShipLevel.text = membership?.data.membershipType?.title ?? "-"
        membershipIcon.image = UIImage(named: membership?.data.membershipType?.icon ?? "ico_star")
        countInvitedLabel.text = referrerCount ?? "-"
    }
    
    func setupView(profile: ProfileInfo?) {
        guard let profile = profile else {
            accountLabel.text = AppConstant.profileInfo?.email
            idAccountLabel.text = AppConstant.profileInfo?.uid.isSecureText()
            phoneNumberLabel.text = AppConstant.phoneNumber?.maskedNationalNoFormatted
            return
        }
        accountLabel.text = profile.email
        idAccountLabel.text = profile.uid.isSecureText()
        phoneNumberLabel.text = AppConstant.phoneNumber?.maskedNationalNoFormatted
    }
    
    public func getCurrentEmail() -> String? {
        return accountLabel.text
    }
    
    // Setup Stack View
    private func setupKycRejectStack(data: [String]) {
        kycRejectMessageStack.removeFullyAllArrangedSubviews()
        data.enumerated().forEach { index, element in
            let view = RejectMessageView()
            view.configView(count: (index + 1).string, data: element)
            kycRejectMessageStack.addArrangedSubview(view)
        }
    }
    
    @objc
    func eyeTapped() {
        isShowId.toggle()
        let image = isShowId ? "ico_eye_show" : "ico_eye_hide"
        eyeAccountImage.image = UIImage(named: image)
        
        let string = idAccountLabel.text.value
        let userid = AppConstant.profileInfo?.uid
        if string.count > 0 {
            idAccountLabel.text = isShowId ? userid : string.isSecureText()
        }
        // Phone
        phoneNumberLabel.text = isShowId ? AppConstant.phoneNumber?.nationalNoFormatted : AppConstant.phoneNumber?.maskedNationalNoFormatted
    }
}

// MARK: - Private

private extension AccountView {
    @objc func verifyKycTapped() {
        delegate?.settingAccountViewVerifyKycLabelTap()
    }
}
