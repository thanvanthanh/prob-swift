//
//  SignUpPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 22/08/2022.
//  
//

import Foundation

class SignUpPresenter: ViewToPresenterSignUpProtocol {
    var agreements: Agreements?
    // MARK: Properties
    var view: PresenterToViewSignUpProtocol?
    var interactor: PresenterToInteractorSignUpProtocol?
    var router: PresenterToRouterSignUpProtocol?
    
    func navigateToLogin() {
        router?.navigateToLogin()
    }
    
    func popToRootView() {
        router?.popToRootView()
    }
    
    func pop() {
        router?.pop()
    }
    
    func register(username: String,
                  password: String,
                  passwordConfirm: String,
                  referralCode: String?) {
        view?.showLoading()
        let agreements = self.agreements ?? Agreements(marketing_privacy: false,
                                                       marketing_mail: false,
                                                       marketing_sms: false)
        
        RecaptchaHelper.shared.recaptchaClient { [weak self] recaptcha in
            guard let `self` = self, let recaptcha = recaptcha else { return }
            self.interactor?.register(username: username,
                                 password: password,
                                 passwordConfirm: passwordConfirm,
                                 referralCode: referralCode,
                                 agreements: agreements,
                                 recaptcha: recaptcha)
        }
        
    }
}

extension SignUpPresenter: InteractorToPresenterSignUpProtocol {
    func sendOTPComplete(email: String) {
        view?.hideLoading()
        router?.navigateToVerification(email: email,
                                       titleNavigation: "login_btn_login".Localizable())
    }
    
    func handerApiError(error: ServiceError) {
        view?.hideLoading()
        view?.handerApiError(error: error)
    }
}
