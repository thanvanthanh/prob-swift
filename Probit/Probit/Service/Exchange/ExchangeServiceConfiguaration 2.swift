//
//  ExchangeServiceConfiguaration.swift
//  Probit
//
//  Created by Nguyen Quang on 17/10/2022.
//

import Foundation

enum ExchangeServiceConfiguaration {
    case getOrderBook(marketId: String)
}


extension ExchangeServiceConfiguaration: Configuration {
    var baseURL: String {
        switch self {
        default:
            return Constant.Server.baseAPIURL
        }
    }
    
    var path: String {
        switch self {
        case .getOrderBook:
            return "api/exchange/v1/order_book"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getOrderBook(let marketId):
            return .requestParameters(parameters: ["market_id": marketId])
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [:]
        }
    }
    
}
