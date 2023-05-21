//
//  TradingCompetitionEntity.swift
//  Probit
//
//  Created by Nguyen Quang on 23/09/2022.
//

import Foundation

class TradingCompetitionEntity: InteractorToEntityTradingCompetitionProtocol {
    
    func getListTradecompetition(completionHandler: @escaping (Result<TradingResponse, ServiceError>) -> Void) {
        TradingAPI.shared.getListTradecompetition { result in
            completionHandler(result)
        }
    }
}
