//
//  LoginPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 22/08/2022.
//  
//

import Foundation

enum RequestType {
    case wallet
    case history
    case normal
    case referralProgram
}

class LoginPresenter: ViewToPresenterLoginProtocol {

    // MARK: Properties
    var view: PresenterToViewLoginProtocol?
    var interactor: PresenterToInteractorLoginProtocol?
    var router: PresenterToRouterLoginProtocol?
    var loginResponse: LoginModel? { interactor?.loginResponse }
    var type: LoginType?
    var requestType: RequestType?

    func navigateToVerification(email: String, password: String, state: TFAState?) {
        router?.navigateToVerification(email: email, password: password, tfaState: state)
    }
    
    func navigateToTerms() {
        router?.navigateToTerms(screenFrom: .signUp)
    }
    
    func navigateToForgotPassword() {
        router?.navigateToForgotPassword()
    }
    
    func login(username: String, password: String) {
        var errorMessage = ""
        if password.isEmpty {
            errorMessage  = "alert_signin_failed".Localizable()
        } else if !username.isValidEmail {
            errorMessage  = "alert_signin_failed_unauth_unexpectedwarn".Localizable()
        }
        
        if errorMessage.isEmpty {
            view?.showLoading()
            interactor?.login(username: username,
                              password: password)
        } else {
            view?.loginError(message: errorMessage)
        }
    }
    
    func dismiss() {
        router?.dismiss()
    }
}

extension LoginPresenter: InteractorToPresenterLoginProtocol {
    func loginComplete(email: String, password: String) {
        view?.hideLoading()
        guard let model = loginResponse else { return }
        
        if let fido = model.fido {
            let loginArgument = WithdrawLoginParameter(username: email, password: password, fido: fido)
            router?.navigateToU2F(argument: .login(loginArgument))
            return
        }
        
        if let isSendCode = model.email, isSendCode {
            self.interactor?.startTFA(completion: { [weak self] result in
                guard let `self` = self else { return }
                switch result {
                case .success(let response):
                    self.navigateToVerification(email: email, password: password, state: response.state)
                case .failure(_):
                    self.navigateToVerification(email: email, password: password, state: nil)
                }
            })
            return
        }
        
        if let isSendCode = model.totp, isSendCode {
            router?.navigateToGoogleAuthentication(email: email, password: password)
            return
        }
    
        guard let accessToken = model.accessToken,
              let refreshToken = model.refreshToken else { return }
        AppConstant.accessToken = accessToken
        AppConstant.tokenType = model.tokenType
        AppConstant.refreshToken = refreshToken
        interactor?.getProfileInfo()
    }
    
    func getProfileInfoComplete(isShowTermScreen: Bool) {
        view?.hideLoading()
        guard isShowTermScreen else {
            self.view?.navigateToHome()
            return
        }
        self.router?.navigateToTerms(screenFrom: .signIn)
    }
    
    func handerApiError(error: ServiceError) {
        view?.hideLoading()
        view?.loginError(message: error.message)
    }
}
