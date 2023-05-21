//
//  OTPGeneratorEntity.swift
//  Probit
//
//  Created by Nguyen Quang on 14/09/2022.
//

import Foundation

class OTPGeneratorEntity: InteractorToEntityOTPGeneratorProtocol {
    func login(username: String,
               password: String,
               totp: String,
               completionHandler: @escaping (Result<LoginModel, ServiceError>) -> Void) {
        LoginAPI().login(username: username,
                         password: password,
                         recaptcha: nil,
                         emailCode: nil,
                         totp: totp) { result in
            completionHandler(result)
        }
    }
    
    func getProfileInfo(completionHandler: @escaping (Result<ProfileInfo, ServiceError>) -> Void) {
        HomeAPI().getProfileInfo { result in
            completionHandler(result)
        }
    }
}
