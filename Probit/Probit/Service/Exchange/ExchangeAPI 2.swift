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
}
