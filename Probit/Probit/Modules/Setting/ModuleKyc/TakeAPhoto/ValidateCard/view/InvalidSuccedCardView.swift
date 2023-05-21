//
//  InvalidSuccedCardView.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 16/11/2565 BE.
//

import Foundation
import UIKit

protocol InvalidSuccedCardViewDelegate {
    func doUploadDiffirentId()
    func doProceedAnyway()
    var cardType: TypeCardId { get }
    var fontImage: String { get }
    var backImage: String? { get }
}

class InvalidSuccedCardView: BaseView {
    var delegate: InvalidSuccedCardViewDelegate?
    @IBOutlet weak var makeSureLabel: UILabel!
    @IBOutlet weak var proceedAnywayBtn: StyleButton!
    @IBOutlet weak var upLoaddifferentIdBtn: StyleButton!
    @IBOutlet weak var idValidFailedLabel: UILabel!
    @IBOutlet weak var stackDescription: UIStackView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var fontImage: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var fontView: UIView!
    @IBOutlet weak var topImageHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomImageHeight: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setupUI() {
        super.setupUI()
        let height = (UIScreen.main.bounds.width - 32) * 207 / 343
        topImageHeight.constant = height
        bottomImageHeight.constant = height
        idValidFailedLabel.textAlignment = AppConstant.isLanguageRightToLeft ? .right : .left
    }
    
    func updateView() {
        proceedAnywayBtn.style = .style_2
        if let linkBackImage = delegate?.backImage,
           let url = URL(string: linkBackImage) {
            backImage.load(url: url)
            backView.isHidden = false
        } else {
            backView.isHidden = true
        }
        
        if let linkFontImage = delegate?.fontImage,
           let url = URL(string: linkFontImage) {
            fontImage.load(url: url)
            fontView.isHidden = false
        } else {
            fontView.isHidden = true
        }
    }
    
    override func localizedString() {
        stackDescription.removeFullyAllArrangedSubviews()
        idValidFailedLabel.text = "dialog_notice".Localizable()
        makeSureLabel.text = "kyc_fail_to_read_notice_guide2".Localizable()
        upLoaddifferentIdBtn.setTitle("kyc_fail_to_read_notice_upload_different_id".Localizable(), for: .normal)
        proceedAnywayBtn.setTitle("kyc_fail_to_read_notice_proceed".Localizable(), for: .normal)
        stackDescription.addArrangedSubview(BulletedListView(caution: "kyc_fail_to_read_notice_guide1".Localizable(),
                                                             hiddenDot: true,
                                                             font: UIFont.primary(size: 14.0),
                                                             color: UIColor.color_282828_b6b6b6))
        stackDescription.addArrangedSubview(BulletedListView(caution: "kyc_fail_to_read_notice_condition1".Localizable(),
                                                             font: UIFont.primary(size: 12.0),
                                                             color: UIColor.color_282828_b6b6b6))
        stackDescription.addArrangedSubview(BulletedListView(caution: "kyc_fail_to_read_notice_condition2".Localizable(),
                                                             font: UIFont.primary(size: 12.0),
                                                             color: UIColor.color_282828_b6b6b6))
        stackDescription.addArrangedSubview(BulletedListView(caution: "kyc_fail_to_read_notice_condition3".Localizable(),
                                                             font: UIFont.primary(size: 12.0),
                                                             color: UIColor.color_282828_b6b6b6))

        UIView.animate(withDuration: 0.3) {
            self.superview?.layoutIfNeeded()
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func doUploadDiffirentId(_ sender: Any) {
        delegate?.doUploadDiffirentId()
    }
    
    @IBAction func doProceedAnyway(_ sender: Any) {
        delegate?.doProceedAnyway()
    }
}
