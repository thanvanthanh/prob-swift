//
//  InvalidCardView.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 16/11/2565 BE.
//

import Foundation
import UIKit

protocol InvalidFailedCardViewDelegate {
    func doUploadDiffirentId()
    var cardType: TypeCardId { get }
    var fontImage: String { get }
    var backImage: String? { get }
}

class InvalidFailedCardView: BaseView {
    var delegate: InvalidFailedCardViewDelegate?
    @IBOutlet weak var upLoaddifferentIdBtn: StyleButton!
    @IBOutlet weak var idValidFailedLabel: UILabel!
    @IBOutlet weak var stackDescription: UIStackView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var fontImage: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setupUI() {
        super.setupUI()
        let height = (UIScreen.main.bounds.width - 32) * 207 / 343
        imageHeight.constant = height
        idValidFailedLabel.textAlignment = AppConstant.isLanguageRightToLeft ? .right : .left
    }
    
    func updateView() {
        guard let cardType = delegate?.cardType else { return }
        if cardType == .ID_CARD_FONT_SIDE,
           let linkBackImage = delegate?.backImage,
           let url = URL(string: linkBackImage) {
            backImage.load(url: url)
            backImage.isHidden = false
        } else {
            backImage.isHidden = true
        }
        
        if let linkFontImage = delegate?.fontImage,
           let url = URL(string: linkFontImage) {
            fontImage.load(url: url)
            fontImage.isHidden = false
        } else {
            fontImage.isHidden = true
        }
    }
    
    override func localizedString() {
        stackDescription.removeFullyAllArrangedSubviews()
        idValidFailedLabel.text = "globalkyc_ocr_fail".Localizable()
        upLoaddifferentIdBtn.setTitle("kyc_fail_to_read_invalid_take_another_photo".Localizable(), for: .normal)
        stackDescription.addArrangedSubview(BulletedListView(caution: "globalkyc_ocr_fail_guide1".Localizable(),
                                                             font: UIFont.primary(size: 14.0),
                                                             color: UIColor.color_282828_b6b6b6))
        stackDescription.addArrangedSubview(BulletedListView(caution: "globalkyc_ocr_fail_guide2".Localizable(),
                                                             font: UIFont.primary(size: 14.0),
                                                             color: UIColor.color_282828_b6b6b6))
    }
    
    @IBAction func doTakeAnotherPhoto(_ sender: Any) {
        delegate?.doUploadDiffirentId()
    }
    
}
