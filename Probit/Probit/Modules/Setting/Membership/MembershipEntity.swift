//
//  MembershipEntity.swift
//  Probit
//
//  Created by Thân Văn Thanh on 29/09/2022.
//

import Foundation

class MembershipEntity: InteractorToEntityMembershipProtocol {
    
    func membership(completionHandler: @escaping (Result<MembershipModel, ServiceError>) -> Void) {
        SettingAPI.shared.membership { result in
            completionHandler(result)
        }
    }
    
    func getUserBalance(completionHandler: @escaping (Result<GetUserBalanceResponse, ServiceError>) -> Void) {
        GetUserBalanceAction().apiCall { result in
            completionHandler(result)
        }
    }
}
