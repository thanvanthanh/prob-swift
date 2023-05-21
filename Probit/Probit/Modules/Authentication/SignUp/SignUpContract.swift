//
//  SignUpContract.swift
//  Probit
//
//  Created by Nguyen Quang on 22/08/2022.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewSignUpProtocol: BaseViewProtocol {
    func handerApiError(error: ServiceError)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterSignUpProtocol {
    
    var view: PresenterToViewSignUpProtocol? { get set }
    var interactor: PresenterToInteractorSignUpProtocol? { get set }
    var router: PresenterToRouterSignUpProtocol? { get set }
    var agreements: Agreements? { get set }
    
    func navigateToLogin()
    func popToRootView()
    func pop()
    func register(username: String,
                  password: String,
                  passwordConfirm: String,
                  referralCode: String?)
    
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorSignUpProtocol {
    var presenter: InteractorToPresenterSignUpProtocol? { get set }
    var entity: InteractorToEntitySignUpProtocol? { get set }
    
    func register(username: String,
                  password: String,
                  passwordConfirm: String,
                  referralCode: String?,
                  agreements: Agreements,
                  recaptcha: String?)
    
    func sendOTP(email: String)
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterSignUpProtocol {
    func sendOTPComplete(email: String)
    func handerApiError(error: ServiceError)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterSignUpProtocol {
    func navigateToLogin()
    func navigateToVerification(email: String,
                                titleNavigation: String)
    func popToRootView()
    func pop()
}

protocol InteractorToEntitySignUpProtocol {
    func register(username: String,
                  password: String,
                  passwordConfirm: String,
                  referralCode: String?,
                  agreements: Agreements,
                  recaptcha: String?,
                  completionHandler: @escaping (Result<GenericResponse, ServiceError>) -> Void)
    
    func sendOTP(email: String,
                 completionHandler: @escaping (Result<GenericResponse, ServiceError>) -> Void)
}
