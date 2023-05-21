//
//  ForgotPasswordContract.swift
//  Probit
//
//  Created by Nguyen Quang on 23/08/2022.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewForgotPasswordProtocol: BaseViewProtocol {
    
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterForgotPasswordProtocol {
    var view: PresenterToViewForgotPasswordProtocol? { get set }
    var interactor: PresenterToInteractorForgotPasswordProtocol? { get set }
    var router: PresenterToRouterForgotPasswordProtocol? { get set }
    
    func forgotPassword(of email: String)
    func popToTermScreen()
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorForgotPasswordProtocol {
    var presenter: InteractorToPresenterForgotPasswordProtocol? { get set }
    var entity: InteractorToEntityForgotPasswordProtocol? { get set }
    
    func sendOTP(with email: String)
    func forgotPassword(of email: String)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterForgotPasswordProtocol {
    func forgotPasswordFailed(_ error: ServiceError)
    func sendOTPCompleted(with email: String)
    func sendOTPFailed(_ error: ServiceError)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterForgotPasswordProtocol {
    func navigateToVerification(with email: String)
    func popToTermScreen()
}

protocol InteractorToEntityForgotPasswordProtocol {
    func sendOTP(email: String,
                 completionHandler: @escaping (Result<GenericResponse, ServiceError>) -> Void)
    func forgotPassword(email: String,
                        completionHandler: @escaping (Result<GenericResponse, ServiceError>) -> Void)
}
