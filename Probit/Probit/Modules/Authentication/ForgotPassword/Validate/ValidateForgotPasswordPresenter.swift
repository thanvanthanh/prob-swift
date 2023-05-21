//
//  ValidateForgotPasswordPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 05/09/2022.
//  
//

import Foundation

class ValidateForgotPasswordPresenter: ViewToPresenterValidateForgotPasswordProtocol {
    // MARK: Properties
    var view: PresenterToViewValidateForgotPasswordProtocol?
    var interactor: PresenterToInteractorValidateForgotPasswordProtocol?
    var router: PresenterToRouterValidateForgotPasswordProtocol?
    
    func processForgotPassword(password: String, confirmPassword: String) {
        view?.showLoading()
        interactor?.processForgotPassword(password: password,
                                          confirmPassword: confirmPassword)
    }
}

// MARK: - InteractorToPresenter
extension ValidateForgotPasswordPresenter: InteractorToPresenterValidateForgotPasswordProtocol {
    func processForgotPasswordSuccess() {
        view?.hideLoading()
        router?.navigateToComplete()
    }
    
    func processForgotPasswordFailed(_ error: ServiceError) {
        view?.hideLoading()
        switch error.issueCode {
        case .USED_PASSWORD:
            view?.showPasswordError(error)
        default:
            view?.showError(error: error)
        }
    }
}
