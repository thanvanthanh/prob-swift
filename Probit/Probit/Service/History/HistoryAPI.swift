//
//  StakeAPI.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 23/09/2565 BE.
//

import Foundation

enum TransactionType: String {
    case all = ""
    case deposit = "deposit"
    case withdrawal = "withdrawal"
}

enum TransactionStatus: String, Codable {
    case done       = "done"
    case requested  = "requested"
    case canceled   = "cancelled"
    case cancelling = "cancelling"
    case pending    = "pending"
    case confirming = "confirming"
    case confirmed  = "confirmed"
    case applying   = "applying"
    case failed     = "failed"
}

class HistoryAPI: BaseAPI<HistoryServiceConfiguaration> {
    static let shared = HistoryAPI()
    
    func getOpenOder(completionHandler: @escaping (Result<DataDTO<[OrderDataEntry]>, ServiceError>) -> Void) {
        fetchData(configuration: .openOder,
                  responseType:DataDTO<[OrderDataEntry]>.self) { result in
            completionHandler(result)
        }
    }
    
    func cancelOpenOrder(marketId: String,
                         orderId: String,
                         completionHandler: @escaping (Result<DataDTO<OrderDataEntry>, ServiceError>) -> Void) {
        fetchData(configuration: .cancelOrder(marketId: marketId, orderId: orderId),
                  responseType: DataDTO<OrderDataEntry>.self) { result in
            completionHandler(result)
        }
    }
    
    func cancelAllOpenOrder(completionHandler: @escaping (Result<DataDTO<[OrderDataEntry]>, ServiceError>) -> Void) {
        fetchData(configuration: .cancelAllOrder,
                  responseType: DataDTO<[OrderDataEntry]>.self) { result in
            completionHandler(result)
        }
    }
    
    func getOrderHistory(startTime: Date,
                         endTime: Date,
                         limit: Int,
                         baseCurrencyId: String?,
                         quoteCurrencyId: String?,
                         completionHandler: @escaping (Result<DataDTO<[OrderDataEntry]>, ServiceError>) -> Void) {
        fetchData(configuration: .ordersHistory(startTime: startTime, endTime: endTime,
                                                limit: limit, baseCurrencyId: baseCurrencyId,
                                                quoteCurrencyId: quoteCurrencyId),
                  responseType:DataDTO<[OrderDataEntry]>.self) { result in
            completionHandler(result)
        }
    }
    
    func getTradeHistory(startTime: Date,
                         endTime: Date,
                         limit: Int,
                         baseCurrencyId: String?,
                         quoteCurrencyId: String?,
                         completionHandler: @escaping (Result<DataDTO<[TradeHistoryEntry]>, ServiceError>) -> Void) {
        fetchData(configuration: .tradeHistory(startTime: startTime, endTime: endTime,
                                               limit: limit, baseCurrencyId: baseCurrencyId,
                                               quoteCurrencyId: quoteCurrencyId),
                  responseType:DataDTO<[TradeHistoryEntry]>.self) { result in
            completionHandler(result)
        }
    }
    
    func getCurrencyWithPlatform(completionHandler: @escaping (Result<DataDTO<[Currency]>, ServiceError>) -> Void) {
        fetchData(configuration: .currencyWithPlatform,
                  responseType:DataDTO<[Currency]>.self) { result in
            completionHandler(result)
        }
    }
    
    func getTransactionHistory(startTime: Date,
                         endTime: Date,
                         currencyId: String,
                               type: String,
                         completionHandler: @escaping (Result<TransactionResonse, ServiceError>) -> Void) {
        fetchData(configuration: .transactionHistory(startTime: startTime, endTime: endTime, limit: 100, currencyId: currencyId, type: type),
                  responseType: TransactionResonse.self) { result in
            completionHandler(result)
        }
    }
    
    func getTransactionDetail(id: String,
                         completionHandler: @escaping (Result<TransactionDetailResonse, ServiceError>) -> Void) {
        fetchData(configuration: .transactionDetail(id: id),
                  responseType: TransactionDetailResonse.self) { result in
            completionHandler(result)
        }
    }
    
    func cancelRequest(transactionId: String, completionHandler: @escaping (Result<CancelTransactionResonse, ServiceError>) -> Void) {
        fetchData(configuration: .cancelTransaction(id: transactionId),
                  responseType: CancelTransactionResonse.self) { result in
            completionHandler(result)
        }
    }
}
