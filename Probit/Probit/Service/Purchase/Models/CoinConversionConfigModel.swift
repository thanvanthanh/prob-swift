//
//  CoinConversionConfigModel.swift
//  Probit
//
//  Created by Bradley Hoang on 30/09/2022.
//

import Foundation

struct GetCoinConversionConfigResponseModel: Decodable {
    let data: CoinConversionConfigDataModel
}

struct CoinConversionConfigDataModel: Decodable {
    let prob: CoinConversionConfigModel

    enum CodingKeys: String, CodingKey {
        case prob = "PROB"
    }
}

// MARK: - CoinConversionConfigModel
struct CoinConversionConfigModel: Decodable {
    let quote: [String]
    let minBaseAmount, maxBaseAmount: Double
    let precision: Double

    enum CodingKeys: String, CodingKey {
        case quote
        case minBaseAmount = "min_base_amount"
        case maxBaseAmount = "max_base_amount"
        case precision
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        quote = try container.decode([String].self, forKey: .quote)
        minBaseAmount = try Double(container.decode(String.self, forKey: .minBaseAmount)) ?? 0.0
        maxBaseAmount = try Double(container.decode(String.self, forKey: .maxBaseAmount)) ?? 0.0
        precision = try container.decode(Double.self, forKey: .precision)
    }
}

enum PurchaseStatus: String, Codable {
    case DONE = "done"
}

struct PurchaseModel: Codable {
    var id, userID, fromCurrencyID, toCurrencyID: String?
    var fromQuantity, toQuantity, price: String?
    var time: Date
    var stake: Bool?
    var status: PurchaseStatus?
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case fromCurrencyID = "from_currency_id"
        case toCurrencyID = "to_currency_id"
        case fromQuantity = "from_quantity"
        case toQuantity = "to_quantity"
        case price, time, stake
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        userID = try container.decode(String.self, forKey: .userID)
        fromCurrencyID = try container.decode(String.self, forKey: .fromCurrencyID)
        toCurrencyID = try container.decode(String.self, forKey: .toCurrencyID)
        fromQuantity = try container.decode(String.self, forKey: .fromQuantity)
        toQuantity = try container.decode(String.self, forKey: .toQuantity)
        price = try container.decode(String.self, forKey: .price)
        let text = try container.decode(String.self, forKey: .status)
        status = PurchaseStatus.init(rawValue: text)
        time = try container.decode(String.self, forKey: .time).toDate() ?? Date()
        stake = try container.decode(Bool.self, forKey: .stake)
    }
}

class PurchaseRequest {
    var fromCurrencyId: String
    var toCurrencyId: String
    var toQuantity: String
    var price: String
    var stake: Bool
    init(fromCurrencyId: String,
         toCurrencyId: String,
         toQuantity: String,
         price: String,
         stake: Bool) {
        self.fromCurrencyId = fromCurrencyId
        self.toCurrencyId = toCurrencyId
        self.toQuantity = toQuantity
        self.price = price
        self.stake = stake
    }
}

struct PurchaseConversionRate: Codable {
    var rate: ConversionRate?
    var expiresAt: String?

    enum CodingKeys: String, CodingKey {
        case rate
        case expiresAt = "expires_at"
    }
}

struct ConversionRate: Codable {
    var usdt: ConversionUsdt?

    enum CodingKeys: String, CodingKey {
        case usdt = "USDT"
    }
}

struct ConversionUsdt: Codable {
    var prob: String?

    enum CodingKeys: String, CodingKey {
        case prob = "PROB"
    }
}
