//
//  StakeServiceConfiguaration.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 23/09/2565 BE.
//

import Foundation
enum HistoryServiceConfiguaration {
    case openOder
    case cancelOrder(marketId: String, orderId: String)
    case cancelAllOrder
    case ordersHistory(startTime: Date, endTime: Date, limit: Int, baseCurrencyId: String?, quoteCurrencyId: String?)
    case tradeHistory(startTime: Date, endTime: Date, limit: Int, baseCurrencyId: String?, quoteCurrencyId: String?)
    case transactionHistory(startTime: Date, endTime: Date, limit: Int, currencyId: String, type: String = "")
    case currencyWithPlatform
    case cancelTransaction(id: String)
    case transactionDetail(id: String)
}


extension HistoryServiceConfiguaration: Configuration {
    var baseURL: String {
        switch self {
        default:
            return Constant.Server.baseAPIURL
        }
    }
    
    var path: String {
        switch self {
        case .openOder:
            return "api/exchange/v1/open_order"
        case .cancelOrder:
            return "api/exchange/v1/cancel_order"
        case .cancelAllOrder:
            return "api/exchange/v1/cancel_order_all"
        case .ordersHistory:
            return "api/exchange/v1/order_history"
        case .tradeHistory:
            return "api/exchange/v1/trade_history"
        case .currencyWithPlatform:
            return "api/exchange/v1/currency_with_platform"
        case .transactionHistory:
            return "api/exchange/v1/transfer/payment"
        case .cancelTransaction:
            return "api/exchange/v1/cancel_withdrawal"
        case .transactionDetail:
            return "api/exchange/v1/transfer/payment/detail"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .cancelOrder, .cancelAllOrder, .cancelTransaction:
            return .post
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .cancelOrder(let marketId,let orderId):
            return .requestParameters(parameters: ["market_id": marketId, "order_id": orderId])
        case .tradeHistory(let startTime,let endTime, let limit,let baseCurrencyId,let quoteCurrencyId):
            var request: [String: Any] = ["start_time": startTime.stringFromDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"),
                                          "end_time": endTime.stringFromDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"),
                                          "limit": limit]
            if let baseCurrencyId = baseCurrencyId {
                request["base_currency_id"] = baseCurrencyId
            }
            if let quoteCurrencyId = quoteCurrencyId  {
                request["quote_currency_id"] = quoteCurrencyId
            }
            return .requestParameters(parameters: request)
        case .ordersHistory(let startTime,let endTime, let limit,let baseCurrencyId,let quoteCurrencyId):
            var request: [String: Any] = ["start_time": startTime.stringFromDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"),
                                          "end_time": endTime.stringFromDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"),
                                          "limit": limit]
            if let baseCurrencyId = baseCurrencyId {
                request["base_currency_id"] = baseCurrencyId
            }
            if let quoteCurrencyId = quoteCurrencyId  {
                request["quote_currency_id"] = quoteCurrencyId
            }
            
            return .requestParameters(parameters: request)
        case .transactionHistory(let startTime, let endTime, let limit, let currencyId, let type):
            var request: [String: Any] = ["start_time": startTime.stringFromDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"),
                                          "end_time": endTime.stringFromDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"),
                                          "limit": limit]
            request["currency_id"] = currencyId
            request["status"] = "requested,confirming,confirmed,pending,done,cancelled,cancelling,failed"
            if !type.isEmpty {
                request["type"] = type
            }
            return .requestParameters(parameters: request)
        case .cancelTransaction(let id):
            let request: [String: Any] = ["id": id]
            return .requestParameters(parameters: request)
        case .transactionDetail(let id):
            let request: [String: Any] = ["id": id]
            return .requestParameters(parameters: request)
        default:
            return .requestParameters(parameters: [:])
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
