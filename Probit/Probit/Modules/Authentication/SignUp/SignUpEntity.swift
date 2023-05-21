//
//  SignUpEntity.swift
//  Probit
//
//  Created by Nguyen Quang on 05/09/2022.
//

import Foundation

class SignUpEntity: InteractorToEntitySignUpProtocol {
    func register(username: String,
                  password: String,
                  passwordConfirm: String,
                  referralCode: String?,
                  agreements: Agreements,
                  recaptcha: String?,
                  completionHandler: @escaping (Result<GenericResponse, ServiceError>) -> Void) {
        SignUpAPI.shared.register(username: username,
                                  password: password,
                                  passwordConfirm: passwordConfirm,
                                  referralCode: referralCode,
                                  agreements: agreements,
                                  recaptcha: recaptcha) { result in
            completionHandler(result)
        }
    }
    
    func sendOTP(email: String,
                 completionHandler: @escaping (Result<GenericResponse, ServiceError>) -> Void) {
        SignUpAPI.shared.sendSignupMail(email: email) { result in
            completionHandler(result)
        }
    }
}
