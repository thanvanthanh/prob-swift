//
//  TradingCompetitionDetailEntity.swift
//  Probit
//
//  Created by Nguyen Quang on 23/09/2022.
//

import Foundation

class TradingCompetitionDetailEntity: InteractorToEntityTradingCompetitionDetailProtocol {
    
    func getListTradecompetitionDetail(id: String,
                                       completionHandler: @escaping (Result<TradingDetailResponse, ServiceError>) -> Void) {
        TradingAPI.shared.getTradecompetitionDetail(id: id) { result in
            completionHandler(result)
        }
    }
    
    func getLeaderboardTrading(id: String,
                               completionHandler: @escaping (Result<TradingLeaderboard, ServiceError>) -> Void) {
        TradingAPI.shared.getLeaderboardTrading(id: id) { result in
            completionHandler(result)
        }
    }
    
    func checkStep(completionHandler: @escaping (Result<CheckStepModel, ServiceError>) -> Void) {
        SettingAPI.shared.checkStep { result in
            completionHandler(result)
        }
    }
    
    func getStakeUser(completionHandler: @escaping (Result<StakeUserData, ServiceError>) -> Void) {
        TradingAPI.shared.getStakeUser { result in
            completionHandler(result)
        }
    }
    
    func membership(completionHandler: @escaping (Result<MembershipModel, ServiceError>) -> Void) {
        SettingAPI.shared.membership { result in
            completionHandler(result)
        }
    }
}
