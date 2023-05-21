//
//  ForgotPasswordPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 23/08/2022.
//  
//

import Foundation

class ForgotPasswordPresenter: ViewToPresenterForgotPasswordProtocol {

    // MARK: Properties
    var view: PresenterToViewForgotPasswordProtocol?
    var interactor: PresenterToInteractorForgotPasswordProtocol?
    var router: PresenterToRouterForgotPasswordProtocol?
    
    func forgotPassword(of email: String) {
        view?.showLoading()
        interactor?.forgotPassword(of: email)
    }
    
    func popToTermScreen() {
        router?.popToTermScreen()
    }
}

// MARK: - InteractorToPresenterForgotPasswordProtocol
extension ForgotPasswordPresenter: InteractorToPresenterForgotPasswordProtocol {
    func forgotPasswordFailed(_ error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
    
    func sendOTPCompleted(with email: String) {
        view?.hideLoading()
        router?.navigateToVerification(with: email)
    }
    
    func sendOTPFailed(_ error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
}
