//
//  WithdrawVerificationContract.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 01/12/2565 BE.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewWithdrawVerificationProtocol {
    func hideLoading()
    func showLoading()
    func showError(error: ServiceError)
    func showSuccess(message: String)
    func navigateToHome()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterWithdrawVerificationProtocol {
    var view: PresenterToViewWithdrawVerificationProtocol? { get set }
    var interactor: PresenterToInteractorWithdrawVerificationProtocol? { get set }
    var router: PresenterToRouterWithdrawVerificationProtocol? { get set }
    var withdrawResponse: WithdrawVerificationResponse? { get }
    func viewDidLoad()
    func viewWillDisappear()
    func beginVerify()
    func startConnectYubi()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorWithdrawVerificationProtocol {
    var presenter: InteractorToPresenterWithdrawVerificationProtocol? { get set }
    var withdrawResponse: WithdrawVerificationResponse? { get }
    var loginResponse: LoginModel? { get set }
    func login(parameter: TFALoginParameter)
    func verifyTFA(parameter: TFAWithdrawParameter)
    func sendTFAEmail(_ sessionId: String, completion: @escaping (Result<WithdrawSendEmailResponse, ServiceError>) -> Void)
    func getProfileInfo()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterWithdrawVerificationProtocol {
    func getWithdrawResponseSuccesed()
    func handerApiError(error: ServiceError)
    func loginComplete(username: String, password: String)
    func getProfileInfoComplete(isShowTermScreen: Bool)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterWithdrawVerificationProtocol {
    func navigateToVerification(email: String, password: String, tfaState: TFAState?)
    func navigateToTerms(screenFrom: AuthScreenFrom)
    func navigateToGoogleAuthentication(email: String, password: String)
}

enum PURPOSE: String {
    case LOGIN = "login"
}
