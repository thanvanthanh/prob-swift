//
//  PurchaseServiceConfiguration.swift
//  Probit
//
//  Created by Bradley Hoang on 30/09/2022.
//

import Foundation

enum PurchaseServiceConfiguration {
    case getCoinConversionRate
    case getCoinConversionConfig
    case buyCoinConversion(fromCurrencyId: String, toCurrencyId: String,
                           toQuantity: String,
                           price: String, stake: Bool)
    case getHistoryConversion(currencyId: String)
}

extension PurchaseServiceConfiguration: Configuration {
    var baseURL: String {
        switch self {
        default:
            return Constant.Server.baseAPIURL
        }
    }
    
    var path: String {
        switch self {
        case .getCoinConversionRate:
            return "api/exchange/v1/coin_conversion_rate"
        case .getCoinConversionConfig:
            return "api/exchange/v1/coin_conversion_config"
        case .buyCoinConversion, .getHistoryConversion:
            return "api/exchange/v1/coin_conversion"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .buyCoinConversion:
            return .post
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .buyCoinConversion(let fromCurrencyId, let toCurrencyId,
                                let toQuantity,let price,let stake):
            let param: [String: Any] = ["from_currency_id": fromCurrencyId,
                                        "to_currency_id": toCurrencyId,
                                        "to_quantity": toQuantity,
                                        "price": price,
                                        "stake": stake]
            
            return .requestParameters(parameters: param)
        case .getHistoryConversion(_):
            let param: [String: Any] = [:]
            return .requestParameters(parameters: param)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [:]
        }
    }
    
    var data: Data? {
        return nil
    }
}
