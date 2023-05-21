//
//  OTPGeneratorPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 06/09/2022.
//  
//

import Foundation

class OTPGeneratorPresenter: ViewToPresenterOTPGeneratorProtocol {
    // MARK: Properties
    var email: String?
    var password: String?
    var type: AuthScreenFrom?
    var view: PresenterToViewOTPGeneratorProtocol?
    var interactor: PresenterToInteractorOTPGeneratorProtocol?
    var router: PresenterToRouterOTPGeneratorProtocol?
    var loginResponse: LoginModel? { interactor?.loginResponse }
    
    func login(totp: String) {
        guard let email = email, let password = password else { return }
        view?.showLoading()
        interactor?.login(username: email, password: password, totp: totp)
    }
    
    func getProfileInfo() {
        view?.showLoading()
        interactor?.getProfileInfo()
    }
    
    func navigateToLogin() {
        router?.navigateToLogin()
    }
}

extension OTPGeneratorPresenter: InteractorToPresenterOTPGeneratorProtocol {
    func loginComplete(email: String, password: String) {
        view?.hideLoading()
        guard let model = loginResponse else { return }
        if let isSendCode = model.email, isSendCode {
            router?.navigateToVerification(email: email, password: password)
            return
        }
        guard let accessToken = model.accessToken,
              let refreshToken = model.refreshToken else { return }
        AppConstant.accessToken = accessToken
        AppConstant.tokenType = model.tokenType
        AppConstant.refreshToken = refreshToken
//        AppDelegate.shared.requestForNrewToken()
        getProfileInfo()
    }
    
    func getProfileInfoComplete(isShowTermScreen: Bool) {
        view?.hideLoading()
        guard isShowTermScreen else {
            self.view?.navigateToHome()
            return
        }
        self.router?.navigateToTerms()
    }
    
    func handerApiError(error: ServiceError) {
        view?.hideLoading()
        view?.otpInvalid(error: error)
    }
}
