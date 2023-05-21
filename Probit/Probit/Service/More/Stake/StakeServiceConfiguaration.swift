//
//  StakeServiceConfiguaration.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 23/09/2565 BE.
//

import Foundation
enum StakeServiceConfiguaration {
    case stakeEvent
    case stakeAmount(currencyId: String)
    case stakeCurrency
    case balance
    case stakeDetail(currencyId: String)
    case stake(currencyId: String, period: Int, amount: String)
    case unStake(currencyId: String, amount: String)
    case getAddressDeposit(platformId: String, allocate: Bool?)
}

extension StakeServiceConfiguaration: Configuration {
    var baseURL: String {
        switch self {
        default:
            return Constant.Server.baseAPIURL
        }
    }
    
    var path: String {
        switch self {
        case .stakeEvent:
            return "api/event/v1/stake_event"
        case .stakeAmount:
            return "api/account/v1/stake_amount"
        case .stakeCurrency:
            return "api/event/v1/stake_currency"
        case .balance:
            return "api/exchange/v1/balance"
        case .stakeDetail:
            return "api/account/v1/stake_detail"
        case .stake:
            return "api/account/v1/stake"
        case .unStake:
            return "api/account/v1/unstake"
        case .getAddressDeposit:
            return "api/exchange/v1/deposit_address"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .stake, .unStake:
            return .post
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .stakeAmount(let currencyId):
            return .requestParameters(parameters: ["currency_id":currencyId])
        case .stakeDetail(let currencyId):
            return .requestParameters(parameters: ["currency_id":currencyId,
                                                   "stake_type": "user"])
        case .stake(let currencyId,let period,let amount):
            return .requestParameters(parameters: ["currency_id": currencyId,
                                                   "amount": amount,
                                                   "period": period])
        case .unStake(let currencyId,let amount):
            return .requestParameters(parameters: ["currency_id": currencyId,
                                                   "amount": amount])
        case .getAddressDeposit(let _platformId, let allocate):
            var parameters: [String:Any] = ["platform_id" : _platformId]
            if let _allocate = allocate {
                parameters["allocate"] = _allocate
            }
            return .requestParameters(parameters: parameters)
        default:
            return .requestParameters(parameters: [:])
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
