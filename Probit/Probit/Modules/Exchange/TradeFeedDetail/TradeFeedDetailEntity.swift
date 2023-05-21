//
//  TradeFeedDetailEntity.swift
//  Probit
//
//  Created by Nguyen Quang on 26/10/2022.
//

import Foundation

class TradeFeedDetailEntity: InteractorToEntityTradeFeedDetailProtocol {
    func newOrder(limitPrice: String?, marketId: String,
                  quantity: String, side: OrderSide,
                  type: ReportTrade,
                  completionHandler: @escaping (Result<DataDTO<NewOrder>, ServiceError>) -> Void) {
        ExchangeAPI.shared.newOrder(limitPrice: limitPrice,
                                    marketId: marketId,
                                    quantity: quantity, side: side, type: type) { result in
            completionHandler(result)
        }
    }
}
