//
//  ConfirmPaymentInteractor.swift
//  Probit
//
//  Created by Thân Văn Thanh on 26/08/2022.
//  
//

import Foundation

class ConfirmPaymentInteractor: PresenterToInteractorConfirmPaymentProtocol {

    // MARK: Properties
    var presenter: InteractorToPresenterConfirmPaymentProtocol?
    var paymentParams: PamentChanelParameters?    
    var paymentInfo: [PaymentInfo] = []
    var exchange: String?
    var method: String?
    
    func getData() {
        let spendNormal = "\(paymentParams?.fiatAmount ?? "") \(paymentParams?.fiat ?? "")"
        let spendRtl = "\(paymentParams?.fiat ?? "") \(paymentParams?.fiatAmount ?? "")"
        let amountSpend = AppConstant.isLanguageRightToLeft ? spendRtl : spendNormal
        
        let priceNormal = "1 \(paymentParams?.crypto ?? "") ≈ \(exchange.value.replaceCurrency()) \(paymentParams?.fiat ?? "")"
        let priceRtl = "\(paymentParams?.fiat ?? "") \(exchange.value.replaceCurrency()) ≈ \(paymentParams?.crypto ?? "") 1"
        
        let price = AppConstant.isLanguageRightToLeft ? priceRtl : priceNormal
        
        paymentInfo = [
            PaymentInfo(title: "buycrypto_confirmpayment_payinfo_serviceprovider_title".Localizable(),
                        amount: method ?? "",
                        image: method.value.lowercased(),
                        type: .provider),
            
            PaymentInfo(title: "buycrypto_confirmpayment_payinfo_fiatamount_title".Localizable(),
                        amount: amountSpend,
                        image: (paymentParams?.fiat).value,
                        type: .spend),
            
            PaymentInfo(title: "buycrypto_confirmpayment_payinfo_price_title".Localizable(),
                        amount: price,
                        image: (paymentParams?.crypto).value,
                        type: .price)
        ]
        presenter?.dataListDidFetch()
    }
}
