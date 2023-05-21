//
//  ValidateForgotPasswordInteractor.swift
//  Probit
//
//  Created by Thân Văn Thanh on 05/09/2022.
//  
//

import Foundation

class ValidateForgotPasswordInteractor: PresenterToInteractorValidateForgotPasswordProtocol {
    // MARK: Properties
    var presenter: InteractorToPresenterValidateForgotPasswordProtocol?
    
    var email: String?
    
    func processForgotPassword(password: String, confirmPassword: String) {
        guard let email = email else {
            presenter?.processForgotPasswordFailed(.notFoundData)
            return
        }
        let requestModel = ForgotPasswordProcessRequestModel(email: email,
                                                             password: password,
                                                             confirmPassword: confirmPassword,
                                                             tfaSessionId: nil,
                                                             service: "global")
        ForgotPasswordAPI.shared.processForgotPassword(requestModel: requestModel) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.presenter?.processForgotPasswordSuccess()
            case let .failure(error):
                self.presenter?.processForgotPasswordFailed(error)
            }
        }
    }
}
