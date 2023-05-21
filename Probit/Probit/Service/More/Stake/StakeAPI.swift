//
//  StakeAPI.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 23/09/2565 BE.
//

import Foundation
class StakeAPI: BaseAPI<StakeServiceConfiguaration> {
    static let shared = StakeAPI()
    
    func getStakeEvent(completionHandler: @escaping (Result<DataDTO<[StakeEvent]>, ServiceError>) -> Void) {
        fetchData(configuration: .stakeEvent,
                  responseType: DataDTO<[StakeEvent]>.self) { result in
            completionHandler(result)
        }
    }
    
    func getStakeAmount(_ currencyId: String,
                        completionHandler: @escaping (Result<DataDTO<StakeAmountModel>, ServiceError>) -> Void) {
        fetchData(configuration: .stakeAmount(currencyId: currencyId),
                  responseType: DataDTO<StakeAmountModel>.self) { result in
            completionHandler(result)
        }
    }
    
    func getStakeCurrency(completionHandler: @escaping (Result<DataDTO<[StakeCurrency]>, ServiceError>) -> Void) {
        fetchData(configuration: .stakeCurrency,
                  responseType: DataDTO<[StakeCurrency]>.self) { result in
            completionHandler(result)
        }
    }
    
    func getStakeDetail(_ currencyId: String,
                        completionHandler: @escaping (Result<StakeDetailDataModel, ServiceError>) -> Void) {
        fetchData(configuration: .stakeDetail(currencyId: currencyId),
                  responseType: StakeDetailDataModel.self) { result in
            completionHandler(result)
        }
    }
    
    func getBalance(completionHandler: @escaping (Result<DataDTO<[UserBalance]>, ServiceError>) -> Void) {
        fetchData(configuration: .balance,
                  responseType: DataDTO<[UserBalance]>.self) { result in
            completionHandler(result)
        }
    }
    
    func postStake(_ currencyId: String,_ period: Int,_ amount: String,completionHandler: @escaping (Result<DataDTO<String>, ServiceError>) -> Void) {
        fetchData(configuration: .stake(currencyId: currencyId,
                                        period: period,
                                        amount: amount),
                  responseType: DataDTO<String>.self) { result in
            completionHandler(result)
        }
    }
    
    func postUnStake(_ currencyId: String,_ amount: String,completionHandler: @escaping (Result<DataDTO<String>, ServiceError>) -> Void) {
        fetchData(configuration: .unStake(currencyId: currencyId,
                                        amount: amount),
                  responseType: DataDTO<String>.self) { result in
            completionHandler(result)
        }
    }
    
    func getAddressDeposit( _ platformId: String,
                            _ allowcate: Bool?,
                           completionHandler: @escaping (Result<DataDTO<[DepositAddress]>, ServiceError>) -> Void) {
        fetchData(configuration: .getAddressDeposit(platformId: platformId,
                                                    allocate: allowcate),
                  responseType: DataDTO<[DepositAddress]>.self) { result in
            completionHandler(result)
        }
    }
}
