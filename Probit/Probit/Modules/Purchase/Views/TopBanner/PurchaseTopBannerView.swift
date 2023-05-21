//
//  PurchaseTopBannerView.swift
//  Probit
//
//  Created by Bradley Hoang on 28/09/2022.
//

import UIKit

protocol PurchaseTopBannerViewDelegate: AnyObject {
    func purchaseTopBannerHintLabelTap(with nextLevel: Double)
    var purchaseRequest: PurchaseRequest? { get set}
}

final class PurchaseTopBannerView: BaseView {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var levelUpVipHintContainerView: UIView!
    @IBOutlet private weak var levelUpVipHintLabel: UILabel!
    @IBOutlet private weak var currentVipLabel: UILabel!
    @IBOutlet private weak var currentStakeAmount: UILabel!
    @IBOutlet private weak var nextVipLabel: UILabel!
    @IBOutlet private weak var nextVipPointLabel: UILabel!
    @IBOutlet private weak var availableBalanceTitleLabel: UILabel!
    @IBOutlet private weak var progressBar: UIProgressView!
    @IBOutlet private weak var availableBalanceValueLabel: UILabel!
    
    // MARK: - Public Variable
    weak var delegate: PurchaseTopBannerViewDelegate?

    var membership: MembershipDetailModel? {
        didSet {
            updateUI(with: membership)
        }
    }
    
    var userBalance: UserBalance? {
        didSet {
            updateUI(with: userBalance)
        }
    }
    
    
    // MARK: - Lifecyle
    override func setupUI() {
        super.setupUI()
        currentVipLabel.textAlignment = AppConstant.isLanguageRightToLeft ? .right : .left
        nextVipLabel.textAlignment = AppConstant.isLanguageRightToLeft ? .left : .right
        nextVipPointLabel.textAlignment = AppConstant.isLanguageRightToLeft ? .left : .right
        availableBalanceValueLabel.textAlignment = AppConstant.isLanguageRightToLeft ? .left : .right
    }
    
    override func localizedString() {
        availableBalanceTitleLabel.text = "activity_walletdetails_availablebalance".Localizable()
    }
}

// MARK: - IBAction
private extension PurchaseTopBannerView {
    @IBAction func levelUpVipHintLabelTapped(_ sender: Any) {
        if let nextLevel = membership?.nextLevel.asDouble() {
            delegate?.purchaseTopBannerHintLabelTap(with: nextLevel)
        }
    }
}

// MARK: - Private
private extension PurchaseTopBannerView {
    
    func updateUI(with balance: UserBalance?) {
        if let available = balance?.available.asDouble().fractionDigits(){
            availableBalanceValueLabel.text = AppConstant.isLanguageRightToLeft ? "PROB \(available)" : "\(available) PROB"
        }
    }
    
    func updateUI(with membership: MembershipDetailModel?) {
        currentVipLabel.text = membership?.membershipType?.title?.capitalized
        nextVipLabel.text = membership?.membershipNextLevel?.title?.uppercased()
        if let stakeAmount = membership?.stakeAmount,
           let nextLevel = membership?.nextLevel  {
            let totalValue = nextLevel.asDouble() + stakeAmount.asDouble()
            currentStakeAmount.text = AppConstant.isLanguageRightToLeft ? "PROB \(stakeAmount)" : "\(stakeAmount) PROB"
            nextVipPointLabel.text = AppConstant.isLanguageRightToLeft ? "≥ PROB \(Int(totalValue))" : "≥ \(Int(totalValue)) PROB"
            progressBar.progress = Float(stakeAmount.asDouble()/totalValue)
        } else {
            currentStakeAmount.text = ""
            nextVipPointLabel.text = ""
            progressBar.progress = Float(0.0)
        }
        if let prob = membership?.nextLevel,
           let vip = membership?.membershipNextLevel?.title?.uppercased() {
            let text = AppConstant.isLanguageRightToLeft ? "PROB \(prob)".forceUnicodeRTL() : "\(prob) PROB"
            let localizable = "membershiplevel_tolevel".Localizable().replacingOccurrences(of: "PROB", with: "")
            levelUpVipHintLabel.attributedText = String(format: localizable, text, vip)
                .setUnderline(textList: [text, vip],
                              attributes: getNextVipLevelAttributes(false),
                              underlineAttributes: getNextVipLevelAttributes(true))
            levelUpVipHintContainerView.isHidden = false
        } else {
            levelUpVipHintContainerView.isHidden = true
        }
    }
    
    func getNextVipLevelAttributes(_ isUnderline: Bool) -> [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.foregroundColor: isUnderline ? UIColor.color_4231c8_6f6ff7 : UIColor(hexString: "7B7B7B"),
            NSAttributedString.Key.font: isUnderline ? UIFont(name: "SFPro-Medium", size: 14)! : UIFont(name: "SFPro-Medium", size: 14)!
        ]
    }
}
