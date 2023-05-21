//
//  ExchangeDetailEntity.swift
//  Probit
//
//  Created by Dang Nguyen on 04/01/2023.
//

import Foundation

class ExchangeDetailEntity: InteractorToEntityExchangeDetailProtocol {

    var getTicker: GetTickerAction = GetTickerAction(dataSource: GatewayApiProductService())
    
    func getExchangeTicker(completionHandler: @escaping ([Ticker]) -> ()) {
        getTicker.apiCall { result in
            switch result {
            case .success(let res):
                completionHandler(res.data)
            case .failure(_):
                completionHandler([Ticker]())
            }
        }
    }
    
    func getListMaket(completionHandler: @escaping ([Market]) -> ()) {
        HomeAPI.shared.getListMaket { result in
            switch result {
            case .success(let res):
                completionHandler(res.data)
            case .failure(_):
                completionHandler([])
            }
        }
    }
}
