//
//  SignUpAPI.swift
//  Probit
//
//  Created by Nguyen Quang on 05/09/2022.
//

import Foundation

class SignUpAPI: BaseAPI<SignUpServiceConfiguration> {
    static let shared = SignUpAPI()
    
    func register(username: String,
                  password: String,
                  passwordConfirm: String,
                  referralCode: String?,
                  agreements: Agreements,
                  recaptcha: String?,
                  completionHandler: @escaping (Result<GenericResponse, ServiceError>) -> Void) {
        fetchData(configuration: .register(username: username,
                                           password: password,
                                           passwordConfirm: passwordConfirm,
                                           agreements: agreements,
                                           referralCode: referralCode,
                                           recaptcha: recaptcha),
                  responseType: GenericResponse.self) { result in
            completionHandler(result)
        }
    }
    
    func reCaptcha(username: String,
                   password: String,
                   passwordConfirm: String,
                   referralCode: String?,
                   agreements: Agreements,
                   completionHandler: @escaping (Result<ReCaptchaModel, ServiceError>) -> Void) {
        fetchData(configuration: .register(username: username,
                                           password: password,
                                           passwordConfirm: passwordConfirm,
                                           agreements: agreements,
                                           referralCode: referralCode,
                                           recaptcha: nil),
                  responseType: ReCaptchaModel.self) { result in
            completionHandler(result)
        }
    }
    
    func sendSignupMail(email: String,
                        completionHandler: @escaping (Result<GenericResponse, ServiceError>) -> Void) {
        fetchData(configuration: .sendSignupMail(email: email),
                  responseType: GenericResponse.self) { result in
            completionHandler(result)
        }
    }
    
    func signupProcess(email: String,
                       code: String,
                       completionHandler: @escaping (Result<GenericResponse, ServiceError>) -> Void) {
        fetchData(configuration: .signupProcess(code: code, email: email),
                  responseType: GenericResponse.self) { result in
            completionHandler(result)
        }
    }
}
