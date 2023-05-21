//
//  SettingEntity.swift
//  Probit
//
//  Created by Thân Văn Thanh on 29/09/2022.
//

import Foundation

class SettingEntity: InteractorToEntitySettingProtocol {
    
    private var getUserBalance: GetUserBalanceAction!

    init() {
        getUserBalance = GetUserBalanceAction()
    }
    
    func membership(completionHandler: @escaping (Result<MembershipModel, ServiceError>) -> Void) {
        SettingAPI.shared.membership { result in
            completionHandler(result)
        }
    }
    
    func referrerCount(completionHandler: @escaping (Result<ReferrerCountModel, ServiceError>) -> Void) {
        SettingAPI.shared.referrerCount { result in
            completionHandler(result)
        }
    }
    
    func getPayInProb(completionHandler: @escaping (Result<GetPayInProbModel, ServiceError>) -> Void) {
        SettingAPI.shared.getPayInProb { result in
            completionHandler(result)
        }
    }
    
    func postPayInProb(param: Bool, completionHandler: @escaping (Result<PostPayInProbModel, ServiceError>) -> Void) {
        SettingAPI.shared.postPayInProb(param: param) { result in
            completionHandler(result)
        }
    }
    
    func checkStep(completionHandler: @escaping (Result<CheckStepModel, ServiceError>) -> Void) {
        SettingAPI.shared.checkStep { result in
            completionHandler(result)
        }
    }
    
    func userKycStatus(completionHandler: @escaping (Result<UserKycStatusModel, ServiceError>) -> Void) {
        SettingAPI.shared.userKycStatus { result in
            completionHandler(result)
        }
    }
    
    func getProfileInfo(completionHandler: @escaping (Result<ProfileInfo, ServiceError>) -> Void) {
        HomeAPI().getProfileInfo { result in
            completionHandler(result)
        }
    }
    
    func getBalance(completion: @escaping (Result<GetUserBalanceResponse, ServiceError>) -> Void) {
        getUserBalance.apiCall(completionHandler: completion)
    }
    
    func getPhoneNumber(completion completionHandler: @escaping (Result<PrimaryphoneResponse, ServiceError>) -> Void) {
        HomeAPI().getPhoneNumber { result in
            completionHandler(result)
        }
    }
}
