//
//  LoginEntity.swift
//  Probit
//
//  Created by Nguyen Quang on 14/09/2022.
//

import Foundation

class LoginEntity: InteractorToEntityLoginProtocol {
    func login(username: String,
               password: String,
               completionHandler: @escaping (Result<LoginModel, ServiceError>) -> Void) {
        RecaptchaHelper.shared.recaptchaClient { recaptchaToken in
            LoginAPI().login(username: username,
                             password: password,
                             recaptcha: recaptchaToken,
                             emailCode: nil,
                             totp: nil) { result in
                completionHandler(result)
            }
        }
    }
    
    func getProfileInfo(completionHandler: @escaping (Result<ProfileInfo, ServiceError>) -> Void) {
        HomeAPI().getProfileInfo { result in
            completionHandler(result)
        }
    }
    
    func startTFA(completion: @escaping  (Result<WithdrawVerificationResponse, ServiceError>) -> Void) {
        WithdrawVerificationAPI.shared.startTFANewV1(purpose: .LOGIN, completionHandler: completion)
    }
}
