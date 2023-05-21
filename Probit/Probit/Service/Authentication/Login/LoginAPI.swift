//
//  LoginAPI.swift
//  Probit
//
//  Created by Beacon on 05/09/2022.
//

import Foundation

protocol LoginAPIProtocol {
    func login(username: String,
               password: String,
               recaptcha: String?,
               emailCode: String?,
               totp: String?,
               completionHandler: @escaping (Result<LoginModel, ServiceError>) -> Void)
    func refreshToken(completionHandler: @escaping (Result<LoginModel, ServiceError>) -> Void)
}

class LoginAPI: BaseAPI<LoginServiceConfiguration>, LoginAPIProtocol {
    
    func login(username: String,
               password: String,
               recaptcha: String?,
               emailCode: String?,
               totp: String?,
               completionHandler: @escaping (Result<LoginModel, ServiceError>) -> Void) {
        self.fetchData(configuration: .login(username: username,
                                             password: password,
                                             recaptcha: recaptcha,
                                             emailCode: emailCode,
                                             totp: totp),
                       responseType: LoginModel.self,
                       completionHandler: { result in
            completionHandler(result)
        })
    }
    
    func refreshToken(completionHandler: @escaping (Result<LoginModel, ServiceError>) -> Void) {
        self.fetchData(configuration: .refreshToken,
                       responseType: LoginModel.self,
                       completionHandler: { result in
            completionHandler(result)
        })
    }
}
