//
//  TradingServiceConfiguration.swift
//  Probit
//
//  Created by Nguyen Quang on 23/09/2022.
//

import Foundation
import Alamofire

enum TradingServiceConfiguration {
    case getListTradecompetition
    case getTradecompetitionDetail(id: String)
    case tradecompetitionLeaderboard(id: String)
    case getStakeUser
}

extension TradingServiceConfiguration: Configuration {
    var baseURL: String {
        switch self {
        default:
            return Constant.Server.baseAPIURL
//            return "https://www.probit.com/"
        }
    }
    
    var path: String {
        switch self {
        case .getListTradecompetition:
            return "api/event/v1/tradecompetition_list"
        case .getTradecompetitionDetail(let id):
            return "api/event/v1/tradecompetition_detail/\(id)"
        case .tradecompetitionLeaderboard(let id):
            return "api/event/v1/tradecompetition_leaderboard/\(id)"
        case .getStakeUser:
            return "api/account/v1/stake/user"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getListTradecompetition, .getTradecompetitionDetail, .tradecompetitionLeaderboard:
            return .get
        case .getStakeUser:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getListTradecompetition, .getTradecompetitionDetail, .tradecompetitionLeaderboard:
            return .requestPlain
        case .getStakeUser:
            return .requestPlain
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
