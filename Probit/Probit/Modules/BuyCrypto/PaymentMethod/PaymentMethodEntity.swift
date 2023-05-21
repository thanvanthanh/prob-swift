//
//  PaymentMethodEntity.swift
//  Probit
//
//  Created by Thân Văn Thanh on 25/08/2022.
//

import Foundation

enum ProviderHeaderType {
    case promotion
    case service
    case header
}

struct PaymentMethodSection {
    let type: ProviderHeaderType
    let headerSection: BaseView?
    var listData: [ServiceProvider]
}

class ServiceProvider {
    var name: String
    var price: String
    var amount: String
    var image: String
    var paymentType: [String]
    var range: [String]
    var isSelected: Bool = false
    var available: Bool = true
    let promotion: PromotionDetail?
    
    init(name: String,
         price: String,
         amount: String,
         image: String,
         paymentType: [String],
         range: [String],
         isSelected: Bool,
         available: Bool,
         promotion: PromotionDetail?) {
        self.name = name
        self.price = price
        self.amount = amount
        self.image = image
        self.paymentType = paymentType
        self.isSelected = isSelected
        self.available = available
        self.promotion = promotion
        self.range = range
    }
}

class PaymentMethodEntity: InteractorToEntityListSupportedProtocol {
    func paymentChanel(params: PamentChanelParameters,
                       completionHandler: @escaping (Result<PaymentChannelsModel, ServiceError>) -> Void) {
        BuyCryptoAPI.shared.paymentChanel(params: params) { result in
            completionHandler(result)
        }
    }
        
}

