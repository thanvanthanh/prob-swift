//
//  LoadImageUrl.swift
//  Probit
//
//  Created by Thân Văn Thanh on 19/09/2022.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder

class LoadImageUrl {
    
    static let shared = LoadImageUrl()
    
    ///Fiat currency image
    ///https://static.probit.com/common/logo_image/fiat/$fiatId.svg
    func fiatCurrency(with fiadId: String, in imageView: UIImageView) {
        if let url = URL(string: String(format: CurrencyIconType.fiat.url, fiadId   )) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "ico_currency_default"))
        }
    }
    
    ///Buy crypto provider image
    ///https://static.probit.com/common/logo_image/buy_crypto_provider/$providerId.svg
    func cryptoProviderImage(with providerId: String, in imageView: UIImageView) {
        if let url = URL(string: String(format: CurrencyIconType.provider.url, providerId)) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "ico_currency_default"))
        }
    }
    
    ///Buy crypto payment method image
    ///https://static.probit.com/common/logo_image/buy_crypto_payment_method/$paymentMethodId.svg
    func cryptoPaymentMethodImage(with paymentMethodId: String, in imageView: UIImageView) {
        if let url = URL(string: String(format: CurrencyIconType.payment.url, paymentMethodId)) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "ico_currency_default"))
        }
    }
    
    ///Crypto currency image
    ///https://static.probit.com/files/coin_logo/$cryptoId.png
    func cryptoCurrencyImage(with cryptoId: String, in imageView: UIImageView) {
        if let url = URL(string: String(format: CurrencyIconType.crypto.url, cryptoId)) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "ico_currency_default"))
        }
    }
    
}

