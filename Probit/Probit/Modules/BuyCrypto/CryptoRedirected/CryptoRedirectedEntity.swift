//
//  CryptoRedirectedEntity.swift
//  Probit
//
//  Created by Thân Văn Thanh on 16/09/2022.
//

import Foundation

class CryptoRedirectedEntity: InteractorToEntityCryptoRedirectedProtocol {
    
    func checkout(params: PaymentCheckoutParams,
                  completionHandler: @escaping (Result<PaymentCheckoutModel, ServiceError>) -> Void) {
        BuyCryptoAPI.shared.paymentCheckout(params: params) { result in
            completionHandler(result)
        }
    }
    
    func checkPayment(paymentId: String,
               completionHandler: @escaping (Result<CheckPaymentModel, ServiceError>) -> Void) {
        BuyCryptoAPI.shared.checkPayment(paymentId: paymentId) { result in
            completionHandler(result)
        }
    }
}
