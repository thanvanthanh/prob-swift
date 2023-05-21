//
//  WithdrawEntity.swift
//  Probit
//
//  Created by Dang Nguyen on 03/11/2022.
//

import Foundation

class WithdrawEntity: InteractorToEntityWithdrawProtocol {
    
    func excuteWithdraw(request: WithdrawRequest, completionHandler: @escaping (Result<WidthdrawResponse, ServiceError>) -> Void) {
        WithdrawAPI.shared.withdraw(request: request, completionHandler: { results in
            completionHandler(results)
        })
    }
    
    func getTFAMethod(request: WithdrawRequest, completionHandler: @escaping (Result<WithdrawVerificationResponse, ServiceError>) -> Void) {
        WithdrawVerificationAPI.shared.startTFA(request: request, completionHandler: { results in
            completionHandler(results)
        })
    }
    
    func sendTFAEmail(sessionId: String) {
        WithdrawVerificationAPI.shared.sendEmail(sessionId: sessionId, completionHandler: { _ in
        })
    }
    
    
}
