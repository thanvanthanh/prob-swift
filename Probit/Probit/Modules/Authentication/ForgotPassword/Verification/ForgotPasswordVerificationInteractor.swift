//
//  ForgotPasswordVerificationInteractor.swift
//  Probit
//
//  Created by Thân Văn Thanh on 05/09/2022.
//  
//

import Foundation

class ForgotPasswordVerificationInteractor: PresenterToInteractorForgotPasswordVerificationProtocol {
    // MARK: Properties
    var email: String?
    var presenter: InteractorToPresenterForgotPasswordVerificationProtocol?
    
    func checkMailCode(_ code: String) {
        guard let email = email else {
            presenter?.checkMailCodeFailed(.notFoundData)
            return
        }
        ForgotPasswordAPI.shared.checkMailCode(code, email: email) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.presenter?.checkMailCodeSuccess(with: email)
            case let .failure(error):
                self.presenter?.checkMailCodeFailed(error)
            }
        }
    }
}
