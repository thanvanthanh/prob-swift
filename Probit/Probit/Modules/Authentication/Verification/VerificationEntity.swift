//
//  VerificationEntity.swift
//  Probit
//
//  Created by Nguyen Quang on 06/09/2022.
//

import Foundation

class VerificationEntity: InteractorToEntityVerificationProtocol {
    
    func signupProcess(code: String,
                       email: String,
                       completionHandler: @escaping (Result<GenericResponse, ServiceError>) -> Void) {
        SignUpAPI.shared.signupProcess(email: email, code: code) { result in
            completionHandler(result)
        }
    }
    
    func sendOTP(email: String,
                 completionHandler: @escaping (Result<GenericResponse, ServiceError>) -> Void) {
        SignUpAPI.shared.sendSignupMail(email: email) { result in
            completionHandler(result)
        }
    }
    
    func login(username: String,
               password: String,
               emailCode: String,
               completionHandler: @escaping (Result<LoginModel, ServiceError>) -> Void) {
        RecaptchaHelper.shared.recaptchaClient { recaptchaToken in
            LoginAPI().login(username: username,
                             password: password,
                             recaptcha: recaptchaToken,
                             emailCode: emailCode,
                             totp: nil) { result in
                completionHandler(result)
            }
        }
    }
    
    func excuteVerifyCode(code: String, sessionId: String, type: AuthenticationMethod, completionHandler: @escaping (Result<WithdrawVerificationResponse, ServiceError>) -> Void) {
        WithdrawVerificationAPI.shared.verifyCode(code: code, sessionId: sessionId, type: type, completionHandler: { results in
            completionHandler(results)
        })
    }
    
    func excuteWithdraw(request: WithdrawRequest, completionHandler: @escaping (Result<WidthdrawResponse, ServiceError>) -> Void) {
        WithdrawAPI.shared.withdraw(request: request, completionHandler: { results in
            completionHandler(results)
        })
    }
    
    func sendTFAEmail(sessionId: String, completionHandler: @escaping () -> Void) {
        WithdrawVerificationAPI.shared.sendEmail(sessionId: sessionId, completionHandler: { _ in
            completionHandler()
        })
    }
    
    func sendTFASms(sessionId: String, completionHandler: @escaping () -> Void) {
        WithdrawVerificationAPI.shared.sendSms(sessionId: sessionId, completionHandler: { _ in
            completionHandler()
        })
    }
    
    func callTFAPhone(sessionId: String, completionHandler: @escaping () -> Void) {
        WithdrawVerificationAPI.shared.callPhone(sessionId: sessionId, completionHandler: { _ in
            completionHandler()
        })
    }
    
    func getProfileInfo(completionHandler: @escaping (Result<ProfileInfo, ServiceError>) -> Void) {
        HomeAPI().getProfileInfo { result in
            completionHandler(result)
        }
    }
}

enum AuthScreenFrom {
    case signIn
    case signUp
    case withdraw
}
