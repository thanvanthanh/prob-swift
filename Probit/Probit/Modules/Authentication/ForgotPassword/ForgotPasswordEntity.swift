//
//  ForgotPasswordEntity.swift
//  Probit
//
//  Created by Nguyen Quang on 08/09/2022.
//

import Foundation

class ForgotPasswordEntity: InteractorToEntityForgotPasswordProtocol {
    
    func sendOTP(email: String,
                 completionHandler: @escaping (Result<GenericResponse, ServiceError>) -> Void) {
        ForgotPasswordAPI.shared.sendMail(email: email) { result in
            completionHandler(result)
        }
    }
    
    func forgotPassword(email: String,
                        completionHandler: @escaping (Result<GenericResponse, ServiceError>) -> Void) {
        RecaptchaHelper.shared.recaptchaClient { recaptchaToken in
            ForgotPasswordAPI.shared.forgotPassword(email: email,
                                                    recaptcha: recaptchaToken) { result in
                completionHandler(result)
            }
        }
    }
}
