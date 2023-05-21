//
//  BuyCryptoEntity.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/09/2022.
//

import Foundation

class BuyCryptoEntity: InteractorToEntityBuyCryptoProtocol {
    func listCrypto(completionHandler: @escaping (Result<BuyCryptoModel, ServiceError>) -> Void) {
        BuyCryptoAPI.shared.listCrypto { result in
            completionHandler(result)
        }
    }
    
    func cryptoPrice(fiat: String,
                     crypto: String,
                     completionHandler: @escaping (Result<BuyCryptoPriceModel, ServiceError>) -> Void) {
        BuyCryptoAPI.shared.cryptoPrice(fiat: fiat,
                                        crypto: crypto) { result in
            completionHandler(result)
        }
    }
    
    func defaultFiat(completionHandler: @escaping (Result<DefaultFiatModel, ServiceError>) -> Void) {
        BuyCryptoAPI.shared.defaultFiat { result in
            completionHandler(result)
        }
    }
}
