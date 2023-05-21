//
//  PaymentDetail.swift
//  Probit
//
//  Created by Thân Văn Thanh on 26/08/2022.
//

import UIKit

class PaymentDetail: BaseView {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var paymentType: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    override init() {
        super.init()
    }

    func configView(data: PaymentInfo) {
        setBackgroundColor(color: .clear)
        logoImage.image = UIImage(named: data.image)
        paymentType.text = data.title
        amountLabel.text = data.amount
        switch data.type {
        case .provider:
            LoadImageUrl.shared.cryptoProviderImage(with: data.image, in: logoImage)
        case .spend:
            LoadImageUrl.shared.fiatCurrency(with: data.image, in: logoImage)
        case .price:
            LoadImageUrl.shared.cryptoCurrencyImage(with: data.image, in: logoImage)
        }
    }
    
    func hidenLineView(_ isHide: Bool) {
        lineView.isHidden = isHide
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
