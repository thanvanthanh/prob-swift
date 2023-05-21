//
//  ExchangeOrderBookEntity.swift
//  Probit
//
//  Created by Nguyen Quang on 17/10/2022.
//

import Foundation

class ExchangeOrderBookEntity: InteractorToEntityExchangeOrderBookProtocol {
    func getListOrderBook(marketId: String,
                          completionHandler: @escaping (Result<DataDTO<[OrderBook]>, ServiceError>) -> Void) {
        ExchangeAPI.shared.getListOrderBook(marketId: marketId) { result in
            completionHandler(result)
        }
    }
}
