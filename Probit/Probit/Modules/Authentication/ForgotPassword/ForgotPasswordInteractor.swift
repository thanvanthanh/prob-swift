//
//  ForgotPasswordInteractor.swift
//  Probit
//
//  Created by Nguyen Quang on 23/08/2022.
//  
//

import Foundation

class ForgotPasswordInteractor: PresenterToInteractorForgotPasswordProtocol {
    
    // MARK: Properties
    var presenter: InteractorToPresenterForgotPasswordProtocol?
    var entity: InteractorToEntityForgotPasswordProtocol?
    
    func sendOTP(with email: String) {
        entity?.sendOTP(email: email, completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success:
                self.presenter?.sendOTPCompleted(with: email)
            case let .failure(error):
                self.presenter?.sendOTPFailed(error)
            }
        })
    }
    
    func forgotPassword(of email: String) {
        entity?.forgotPassword(email: email, completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success:
                self.sendOTP(with: email)
            case let .failure(error):
                self.presenter?.forgotPasswordFailed(error)
            }
        })
    }
}
