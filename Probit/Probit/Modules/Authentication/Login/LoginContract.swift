//
//  LoginContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 22/08/2022.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewLoginProtocol: BaseViewProtocol {
    func navigateToHome()
    func loginError(message: String)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterLoginProtocol {
    var loginResponse: LoginModel? { get }
    var view: PresenterToViewLoginProtocol? { get set }
    var interactor: PresenterToInteractorLoginProtocol? { get set }
    var router: PresenterToRouterLoginProtocol? { get set }
    var type: LoginType? { get set }
    var requestType: RequestType? { get set }
    func navigateToVerification(email: String, password: String, state: TFAState?)
    func navigateToTerms()
    func navigateToForgotPassword()
    func login(username: String,
               password: String)
    func dismiss()
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorLoginProtocol {
    var loginResponse: LoginModel? { get set }
    var entity: InteractorToEntityLoginProtocol? { get set }
    var presenter: InteractorToPresenterLoginProtocol? { get set }
    
    func login(username: String,
               password: String)
    func getProfileInfo()
    func startTFA(completion: @escaping  (Result<WithdrawVerificationResponse, ServiceError>) -> Void)

}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterLoginProtocol {
    func loginComplete(email: String, password: String)
    func getProfileInfoComplete(isShowTermScreen: Bool)
    func handerApiError(error: ServiceError)
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterLoginProtocol {
    func navigateToVerification(email: String, password: String, tfaState: TFAState?)
    func navigateToTerms(screenFrom: AuthScreenFrom)
    func navigateToForgotPassword()
    func navigateToGoogleAuthentication(email: String, password: String)
    func dismiss()
    func navigateToU2F(argument: WithdrawVerificationArgument)
}

protocol InteractorToEntityLoginProtocol {
    func login(username: String,
               password: String,
               completionHandler: @escaping (Result<LoginModel, ServiceError>) -> Void)
    func getProfileInfo(completionHandler: @escaping (Result<ProfileInfo, ServiceError>) -> Void)
    func startTFA(completion: @escaping  (Result<WithdrawVerificationResponse, ServiceError>) -> Void)
}


