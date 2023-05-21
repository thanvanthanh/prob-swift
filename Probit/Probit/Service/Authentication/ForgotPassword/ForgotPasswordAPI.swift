//
//  ForgotPasswordAPI.swift
//  Probit
//
//  Created by Nguyen Quang on 08/09/2022.
//

import Foundation

class ForgotPasswordAPI: BaseAPI<ForgotPasswordServiceConfiguration> {
    static let shared = ForgotPasswordAPI()
    
    func forgotPassword(email: String,
                        recaptcha: String?,
                        completionHandler: @escaping (Result<GenericResponse, ServiceError>) -> Void) {
        fetchData(configuration: .forgotPassword(email: email,
                                                 recaptcha: recaptcha),
                  responseType: GenericResponse.self) { result in
            completionHandler(result)
        }
    }
    
    func sendMail(email: String,
                  completionHandler: @escaping (Result<GenericResponse, ServiceError>) -> Void) {
        fetchData(configuration: .sendMail(email: email),
                  responseType: GenericResponse.self) { result in
            completionHandler(result)
        }
    }
    
    func checkMailCode(_ code: String,
                       email: String,
                       completionHandler: @escaping (Result<GenericResponse, ServiceError>) -> Void) {
        fetchData(configuration: .checkMailCode(code,
                                                email: email),
                  responseType: GenericResponse.self) { result in
            completionHandler(result)
        }
    }
    
    func processForgotPassword(requestModel: ForgotPasswordProcessRequestModel,
                               completionHandler: @escaping (Result<GenericResponse, ServiceError>) -> Void) {
        fetchData(configuration: .processForgotPassword(requestModel: requestModel),
                  responseType: GenericResponse.self) { result in
            completionHandler(result)
        }
    }
}
