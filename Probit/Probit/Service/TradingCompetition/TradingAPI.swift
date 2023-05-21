//
//  TradingAPI.swift
//  Probit
//
//  Created by Nguyen Quang on 23/09/2022.
//

import Foundation

class TradingAPI: BaseAPI<TradingServiceConfiguration> {
    static let shared = TradingAPI()
    
    func getListTradecompetition(completionHandler: @escaping (Result<TradingResponse, ServiceError>) -> Void) {
        fetchData(configuration: .getListTradecompetition,
                  responseType: TradingResponse.self) { result in
            completionHandler(result)
        }
    }
    
    func getTradecompetitionDetail(id: String,
                                   completionHandler: @escaping (Result<TradingDetailResponse, ServiceError>) -> Void) {
        fetchData(configuration: .getTradecompetitionDetail(id: id),
                  responseType: TradingDetailResponse.self) { result in
            completionHandler(result)
        }
    }
    
    func getLeaderboardTrading(id: String,
                               completionHandler: @escaping (Result<TradingLeaderboard, ServiceError>) -> Void) {
        fetchData(configuration: .tradecompetitionLeaderboard(id: id),
                  responseType: TradingLeaderboard.self) { result in
            completionHandler(result)
        }
    }
    
    func getStakeUser(completionHandler: @escaping (Result<StakeUserData, ServiceError>) -> Void) {
        fetchData(configuration: .getStakeUser,
                  responseType: StakeUserData.self) { result in
            completionHandler(result)
        }
    }
}
