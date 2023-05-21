//
//  PurchaseFooterView.swift
//  Probit
//
//  Created by Bradley Hoang on 28/09/2022.
//

import UIKit

protocol PurchaseFooterViewDelegate: AnyObject {
    func purchaseFooterStakeLabelAccept(with duration: String)
    func goToHistory()
    var purchaseRequest: PurchaseRequest? { get set}
}

final class PurchaseFooterView: BaseView {
    // MARK: - IBOutlet
    @IBOutlet private weak var checkBoxImageView: UIImageView!
    @IBOutlet private weak var stakeLabel: UILabel!
    @IBOutlet private weak var purchaseHistoryButton: UIButton!
    @IBOutlet private weak var purchaseTimeLabel: UILabel!
    
    // MARK: - Public Variable
    weak var delegate: PurchaseFooterViewDelegate?
    var stakeCurrency: StakeCurrency? {
        didSet {
            updateStakeAutomatically(with: stakeCurrency)
        }
    }
    var isAcceptStake = false {
        didSet {
            acceptStakeAutomatically(isAcceptStake)
        }
    }
    
    // MARK: - Lifecyle
    override func setupUI() {
        setBackgroundColor(color: .clear)
        checkBoxImageView.addTapGesture{ [weak self] in
            self?.showStakeNotice()
        }
        stakeLabel.isUserInteractionEnabled = true
        stakeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stakeLabelTap(_:))))
    }
    
    func setupDarkMode() {
        purchaseHistoryButton.borderColor = UIColor.color_4231c8_6f6ff7
    }
    
    override func localizedString() {
        purchaseHistoryButton.setTitle("activity_buy_prob_purchasehistory".Localizable(), for: .normal)
        purchaseTimeLabel.text = String(format: "activity_buy_prob_warning".Localizable(), "\(PurchaseConstants.countdownTime)")
    }
    
    @IBAction func goToHistory(_ sender: Any) {
        delegate?.goToHistory()
    }
    
    @objc
    func stakeLabelTap(_ tapGesture: UITapGestureRecognizer) {
        let detailString = "dialog_details".Localizable()
        guard let attributedText = self.stakeLabel.attributedText,
              let range = attributedText.string.range(of: detailString) else {
            return
        }
        let linkRange = NSRange(range, in: attributedText.string)
        let locationInRange = tapGesture.didTapAttributedTextInLabel(label: self.stakeLabel, inRange: linkRange)
        
        if locationInRange {
            CommonWebViewRouter().showScreen(titleBackScreen: "common_previous".Localizable(),
                                             urlString: AppConstant.Link.memberShip,
                                             titleNavigation: "ProBit Global")
        } else {
            self.showStakeNotice()
        }
    }
}

// MARK: - Private
private extension PurchaseFooterView {
    func updateStakeAutomatically(with stakeCurrency: StakeCurrency?) {
        let duration = getDuration(from: stakeCurrency)
        let detailString = "dialog_details".Localizable() + "."
        let stakeString = String(format: "activity_buy_prob_stakecheckbox_description".Localizable(), duration) + " \(detailString)"
        stakeLabel.attributedText = stakeString.setUnderline(
            textList: [detailString],
            attributes: getNormalStakeLabelAttributes(),
            underlineAttributes: getDetailStakeLabelAttributes())
    }
    
    func acceptStakeAutomatically(_ isAccept: Bool) {
        checkBoxImageView.image = isAccept ? UIImage(named: "ico_radio_tick") : UIImage(named: "ico_radio_untick")
    }
    
    func getDuration(from stakeCurrency: StakeCurrency?) -> String {
        let duration = stakeCurrency?.period?.first ?? 0
        return duration.hourToString
    }
    
    func showStakeNotice() {
        guard !isAcceptStake else {
            isAcceptStake = false
            return
        }
        let duration = getDuration(from: stakeCurrency)
        delegate?.purchaseFooterStakeLabelAccept(with: duration)
    }
    
    func getNormalStakeLabelAttributes() -> [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.foregroundColor: UIColor.color_282828_fafafa,
            NSAttributedString.Key.font: UIFont(name: "SFPro-Regular", size: 16)!
        ]
    }
    
    func getDetailStakeLabelAttributes() -> [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.foregroundColor: UIColor.color_4231c8_6f6ff7,
            NSAttributedString.Key.font: UIFont(name: "SFPro-Regular", size: 16)!
        ]
    }
}
