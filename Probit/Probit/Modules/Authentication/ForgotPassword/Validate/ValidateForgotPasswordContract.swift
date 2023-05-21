//
//  ValidateForgotPasswordContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 05/09/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewValidateForgotPasswordProtocol: BaseViewProtocol {
   func showPasswordError(_ error: ServiceError)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterValidateForgotPasswordProtocol {
    var view: PresenterToViewValidateForgotPasswordProtocol? { get set }
    var interactor: PresenterToInteractorValidateForgotPasswordProtocol? { get set }
    var router: PresenterToRouterValidateForgotPasswordProtocol? { get set }
    
    func processForgotPassword(password: String,
                               confirmPassword: String)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorValidateForgotPasswordProtocol {
    var presenter: InteractorToPresenterValidateForgotPasswordProtocol? { get set }
    
    var email: String? { get set }
    
    func processForgotPassword(password: String,
                               confirmPassword: String)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterValidateForgotPasswordProtocol {
    func processForgotPasswordSuccess()
    func processForgotPasswordFailed(_ error: ServiceError)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterValidateForgotPasswordProtocol {
    func navigateToComplete()
}
