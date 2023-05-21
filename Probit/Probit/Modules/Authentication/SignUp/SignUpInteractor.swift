//
//  SignUpInteractor.swift
//  Probit
//
//  Created by Nguyen Quang on 22/08/2022.
//  
//

import Foundation

class SignUpInteractor: PresenterToInteractorSignUpProtocol {
    
    // MARK: Properties
    var presenter: InteractorToPresenterSignUpProtocol?
    var entity: InteractorToEntitySignUpProtocol?
    
    func register(username: String,
                  password: String,
                  passwordConfirm: String,
                  referralCode: String?,
                  agreements: Agreements,
                  recaptcha: String?) {
        entity?.register(username: username.asTrimmed,
                         password: password,
                         passwordConfirm: passwordConfirm,
                         referralCode: referralCode,
                         agreements: agreements,
                         recaptcha: recaptcha,
                         completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success:
                self.sendOTP(email: username)
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
        })
    }
    
    func sendOTP(email: String) {
        entity?.sendOTP(email: email,
                        completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success:
                self.presenter?.sendOTPComplete(email: email)
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
        })
    }
}
