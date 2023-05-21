//
//  PromotionHeader.swift
//  Probit
//
//  Created by Thân Văn Thanh on 28/09/2022.
//

import UIKit

class PromotionHeader: BaseView {

    @IBOutlet private weak var iconImage: UIImageView!
    @IBOutlet private weak var promotionLabel: UILabel!
    
    private var type: ProviderHeaderType = .promotion
    
    init(type: ProviderHeaderType) {
        super.init()
        self.type = type
        setupHeader(type: type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupHeader(type: ProviderHeaderType) {
        switch type {
        case .promotion:
            promotionLabel.text = "buycrypto_promotion".Localizable()
            promotionLabel.textColor = .label
            promotionLabel.font = .important(size: 14)
        case .service:
            promotionLabel.text = "buycrypto_confirmpayment_payinfo_serviceprovider_title".Localizable()
            promotionLabel.textColor = UIColor(hexString: "#7B7B7B")
            promotionLabel.font = .primary(size: 14)
            iconImage.isHidden = true
        case .header:
            break
        }
    }

}
