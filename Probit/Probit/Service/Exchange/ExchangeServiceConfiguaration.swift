//
//  ExchangeServiceConfiguaration.swift
//  Probit
//
//  Created by Nguyen Quang on 17/10/2022.
//

import Foundation

enum ExchangeServiceConfiguaration {
    case getOrderBook(marketId: String)
    case newOrder(limitPrice: String?, marketId: String,
                  quantity: String, side: OrderSide, type: ReportTrade)
    case getCandleData(marketIds: String, startTime: String, endTime: String, interval: String, sort: String, limit: Int = 200)
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
        case .newOrder:
            return "api/exchange/v1/new_order"
        case .getCandleData:
//            return "api/exchange/v1/candle"
            return "api/exchange/v1/udf/history"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getOrderBook, .getCandleData:
            return .get
        case .newOrder:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getOrderBook(let marketId):
            return .requestParameters(parameters: ["market_id": marketId])
        case .newOrder(let limitPrice, let marketId, let quantity, let side, let type):
            var parameters: [String: Any] = ["market_id": marketId,
                                             "type": type.rawValue,
                                             "time_in_force": type.timeInForce,
                                             "side": side.rawValue]
            if type == .limit {
                parameters["limit_price"] = limitPrice
                parameters["quantity"] = quantity
            } else {
                if side == .SELL {
                    parameters["quantity"] = quantity
                } else {
                    parameters["cost"] = quantity
                }
            }
            return .requestParameters(parameters: parameters)
        case .getCandleData(let marketIds, let startTime, let endTime, let interval, let sort, let limit):
            let parameters: [String: Any] = ["symbol": marketIds,
                                             "from": startTime,
                                             "to": endTime,
                                             "resolution": interval]
            return .requestParameters(parameters: parameters)
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
