//
//  ForgotPasswordVerificationContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 05/09/2022.
//  
//

import Foundation
import UIKit

// MARK: View Output (Presenter -> View)
protocol PresenterToViewForgotPasswordVerificationProtocol: BaseViewProtocol {
    func showInvalidCodeError()
    func updateResendTime(_ time: Int)
    func showSessionExpiredPopup()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterForgotPasswordVerificationProtocol {
    var view: PresenterToViewForgotPasswordVerificationProtocol? { get set }
    var interactor: PresenterToInteractorForgotPasswordVerificationProtocol? { get set }
    var router: PresenterToRouterForgotPasswordVerificationProtocol? { get set }
    
    var email: String? { get }
    
    func startTimer()
    func stopTimer()
    func becomeActive()
    func resignActive()
    func checkMailCode(_ code: String)
    func popToPreviousView(from vc: UIViewController)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorForgotPasswordVerificationProtocol {
    var presenter: InteractorToPresenterForgotPasswordVerificationProtocol? { get set }
    
    var email: String? { get set }
    
    func checkMailCode(_ code: String)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterForgotPasswordVerificationProtocol {
    func checkMailCodeSuccess(with email: String)
    func checkMailCodeFailed(_ error: ServiceError)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterForgotPasswordVerificationProtocol {
    func navigateToValidateForgotPassword(with email: String)
    func popToPreviousView(from vc: UIViewController)
}
