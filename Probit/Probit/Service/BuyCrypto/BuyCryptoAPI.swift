//
//  BuyCryptoAPI.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/09/2022.
//

import Foundation

class BuyCryptoAPI: BaseAPI<BuyCryptoServiceConfiguration> {
    static let shared = BuyCryptoAPI()
    
    func defaultFiat(completionHandler: @escaping (Result<DefaultFiatModel, ServiceError>) -> Void) {
        fetchData(configuration: .defaultFiatCurrency,
                  responseType: DefaultFiatModel.self) { result in
            completionHandler(result)
        }
    }
    
    func listCrypto(completionHandler: @escaping (Result<BuyCryptoModel, ServiceError>) -> Void) {
        fetchData(configuration: .listCrypto, responseType: BuyCryptoModel.self) { result in
            completionHandler(result)
        }
    }
    
    func cryptoPrice(fiat: String,
                     crypto: String,
                     completionHandler: @escaping (Result<BuyCryptoPriceModel, ServiceError>) -> Void) {
        fetchData(configuration: .cryptoPrice(fiat: fiat,
                                              crypto: crypto),
                  responseType: BuyCryptoPriceModel.self) { result in
            completionHandler(result)
        }
    }
    
    func paymentChanel(params: PamentChanelParameters,
                       completionHandler: @escaping (Result<PaymentChannelsModel, ServiceError>) -> Void) {
        fetchData(configuration: .paymentChanel(params: params),
                  responseType: PaymentChannelsModel.self) { result in
            completionHandler(result)
        }
    }
    
    func paymentCheckout(params: PaymentCheckoutParams,
                         completionHandler: @escaping (Result<PaymentCheckoutModel, ServiceError>) -> Void) {
          fetchData(configuration: .checkout(params: params),
                    responseType: PaymentCheckoutModel.self) { result in
              completionHandler(result)
          }
      }
    
    func checkPayment(paymentId: String,
                      completionHandler: @escaping (Result<CheckPaymentModel, ServiceError>) -> Void) {
        fetchData(configuration: .checkPayment(paymentId: paymentId),
                  responseType: CheckPaymentModel.self) { result in
            completionHandler(result)
        }
    }
}
