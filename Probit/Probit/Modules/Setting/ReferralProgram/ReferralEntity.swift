//
//  ReferralEntity.swift
//  Probit
//
//  Created by Thân Văn Thanh on 11/10/2022.
//

import Foundation

class ReferralEntity: InteractorToEntityReferralProtocol {
    
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
    
    func referrerCode(completionHandler: @escaping (Result<ReferralCodeModel, ServiceError>) -> Void) {
        SettingAPI.shared.referrerCode { result in
            completionHandler(result)
        }
    }
    
    func referrerEarned(completionHandler: @escaping (Result<ReferrerEarned, ServiceError>) -> Void) {
        SettingAPI.shared.referrerEarned { result in
            completionHandler(result)
        }
    }
}
