//
//  BuyCryptoModel.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/09/2022.
//

import Foundation

// MARK: - Default Fiat

struct DefaultFiatModel: Decodable {
    let data: DefaultFiatDetailModel
    
    init(data: DefaultFiatDetailModel) {
          self.data = data
       }

       enum CodingKeys: String, CodingKey {
         case data
       }
    
}

struct DefaultFiatDetailModel: Decodable {
    var localId: String
    
    private struct CustomCodingKeys: CodingKey {
        
        // Use for string-keyed dictionary
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        // Use for integer-keyed dictionary
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)
        self.localId = try container.decode(String.self, forKey: CustomCodingKeys(stringValue: AppConstant.locale)!)
    }
}

// MARK: - List Crypto

struct BuyCryptoModel: Codable {
    var data: BuyCryptoDataModel?
}

struct BuyCryptoDataModel: Codable {
    var crypto: [ListCrypto]
    let fiat: [ListCrypto]
}

struct ListCrypto: Codable {
    let currencyID: String
    var displayName: LocalizableModel?
    var type: CryptoType = .fiat

    enum CodingKeys: String, CodingKey {
        case currencyID = "currency_id"
        case displayName = "display_name"
    }
}

struct ExchangeBuyCryptoModel {
    let min: String
    let max: String
    let amount: String
    let fiat: String
    let crypto: String
}

// MARK: - Crypto Price
struct BuyCryptoPriceModel: Codable {
    let data: PriceCrypto
}

struct PriceCrypto: Codable {
    let fiatAmount, fiatMinAmount, fiatMaxAmount: String

    enum CodingKeys: String, CodingKey {
        case fiatAmount = "fiat_amount"
        case fiatMinAmount = "fiat_min_amount"
        case fiatMaxAmount = "fiat_max_amount"
    }
}

// MARK: - PaymentChannels

struct PaymentChannelsModel: Codable {
    var data: Paymentchanel?
}

struct Paymentchanel: Codable {
    var moonpay: PaymentChanelDetail?
    var banxa: PaymentChanelDetail?
    var simplex: PaymentChanelDetail?
    var xanpool: PaymentChanelDetail?
    var coinify: PaymentChanelDetail?
}

struct PaymentChanelDetail: Codable {
    let details: PaymentDetailRange?
    let available: Bool?
    let method: [String]?
    let fiatAmount: String?
    
    enum CodingKeys: String, CodingKey {
        case details, available, method
        case fiatAmount = "fiat_amount"
    }
}

struct PromotionDetail: Codable {
    let type: String
    let articleId: String
    let startDate: String
    let endDate: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case articleId = "article_id"
        case startDate = "start_date"
        case endDate = "end_date"
    }
}

struct PaymentDetailRange: Codable {
    let range: [String]?
    let promotion: PromotionDetail?
}

struct PamentChanelParameters {
    let fiat: String
    let fiatAmount: String
    let crypto: String
    let cryptoAmount: String
    var isSpend: Bool
    
    var dictionary: [String: Any] {
        return ["fiat": fiat,
                "fiat_amount": fiatAmount,
                "crypto": crypto,
                "crypto_amount": cryptoAmount]
    }
    
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}

// MARK: - PaymentCheckout

struct PaymentCheckoutModel: Codable {
    let data: PaymentCheckoutDetail
}

struct PaymentCheckoutDetail: Codable {
    let redirectPath: String
    let paymentId: String
    
    enum CodingKeys: String, CodingKey {
        case redirectPath = "redirect_path"
        case paymentId = "payment_id"
    }
}

struct PaymentCheckoutParams {
    let provider: String
    let fiatAmount: String?
    let fiat: String
    let crypto: String
    
    var dictionary: [String: Any] {
        return ["provider": provider,
                "fiat_amount": fiatAmount ?? "",
                "fiat": fiat,
                "crypto": crypto]
    }
    
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}

// MARK: CheckPayment

struct CheckPaymentModel: Codable {
    let result: String
}
