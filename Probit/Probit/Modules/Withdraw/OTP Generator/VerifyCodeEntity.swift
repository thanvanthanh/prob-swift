//
//  VerifyCodeEntity.swift
//  Probit
//
//  Created by Dang Nguyen on 03/11/2022.
//

import Foundation

class VerifyCodeEntity: InteractorToVerifyCodeEntityProtocol {
    
    func excuteVerifyCode(code: String, sessionId: String, completionHandler: @escaping (Result<WithdrawVerificationResponse, ServiceError>) -> Void) {
        WithdrawVerificationAPI.shared.verifyCode(code: code, sessionId: sessionId, completionHandler: { results in
            completionHandler(results)
        })
    }
    
    func excuteWithdraw(request: WithdrawRequest, completionHandler: @escaping (Result<WidthdrawResponse, ServiceError>) -> Void) {
        WithdrawAPI.shared.withdraw(request: request, completionHandler: { results in
            completionHandler(results)
        })
    }
    
    func sendTFAEmail(sessionId: String) {
        WithdrawVerificationAPI.shared.sendEmail(sessionId: sessionId, completionHandler: { _ in
        })
    }
    
    func sendTFASms(sessionId: String) {
        WithdrawVerificationAPI.shared.sendSms(sessionId: sessionId, completionHandler: { _ in
        })
    }
    
    func callTFAPhone(sessionId: String) {
        WithdrawVerificationAPI.shared.callPhone(sessionId: sessionId, completionHandler: { _ in
        })
    }
}
