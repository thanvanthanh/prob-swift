//
//  ExchangeAPI.swift
//  Probit
//
//  Created by Nguyen Quang on 17/10/2022.
//

import Foundation

class ExchangeAPI: BaseAPI<ExchangeServiceConfiguaration> {
    static let shared = ExchangeAPI()
    
    func getListOrderBook(marketId: String,
                          completionHandler: @escaping (Result<DataDTO<[OrderBook]>, ServiceError>) -> Void) {
        fetchData(configuration: .getOrderBook(marketId: marketId),
                  responseType: DataDTO<[OrderBook]>.self) { result in
            completionHandler(result)
        }
    }
    
    func newOrder(limitPrice: String?, marketId: String,
                  quantity: String, side: OrderSide, type: ReportTrade,
                  completionHandler: @escaping (Result<DataDTO<NewOrder>, ServiceError>) -> Void) {
        fetchData(configuration: .newOrder(limitPrice: limitPrice,
                                           marketId: marketId,
                                           quantity: quantity, side: side,
                                           type: type),
                  responseType: DataDTO<NewOrder>.self) { result in
            completionHandler(result)
        }
    }
    
    func getCandleData(marketIds: String, startTime: String, endTime: String, interval: String, sort: String,
                       completionHandler: @escaping (Result<CandleValue, ServiceError>) -> Void) {
        fetchData(configuration: .getCandleData(marketIds: marketIds, startTime: startTime, endTime: endTime, interval: interval, sort: sort, limit: 200),
                  responseType: CandleValue.self) { result in
            completionHandler(result)
        }
    }
}
