//
//  VerificationContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 22/08/2022.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewVerificationProtocol: BaseViewProtocol {
    func resendOtp()
    func otpInvalid(error: ServiceError)
    func navigateToHome()
    func sendOTPFail()
    func showAlertExpire(excute: (() -> Void)?)
    var didInputOTP: Bool { get }
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterVerificationProtocol {
    
    var view: PresenterToViewVerificationProtocol? { get set }
    var interactor: PresenterToInteractorVerificationProtocol? { get set }
    var router: PresenterToRouterVerificationProtocol? { get set }
    var email: String? { get set }
    var password: String? { get set }
    var type: AuthScreenFrom? { get set }
    func viewWillAppear()
    func viewWillDisappear()
    func navigateToInputPin()
    func signUpResendOtp()
    func signupProcess(code: String)
    func login(emailCode: String)
    func verifyWithdrawCode(code: String)
    func navigateToHelpEmail()
    func popToRootView()
    func reLogin()
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorVerificationProtocol {
    
    var presenter: InteractorToPresenterVerificationProtocol? { get set }
    var entity: InteractorToEntityVerificationProtocol? { get set }
    var tfaState: TFAState? { get set }
    var withdrawRequest: WithdrawRequest? { get set }
    var type: AuthenticationMethod { get set }
    func signupProcess(code: String, email: String)
    func signUpResendOtp(email: String)
    func login(username: String,
               password: String,
               emailCode: String)
    func getProfileInfo()
    func excuteVerifyCode(code: String)
    func excuteWithdraw(sessId: String)
    func sendTFAEmail()
    func sendTFASms()
    func callTFAPhone()

}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterVerificationProtocol {
    func signupComplete()
    func sendOtpComplete()
    func sendOtpFail()
    func loginSuccessfully()
    func getProfileInfoComplete(isShowTermScreen: Bool)
    func handerApiError(error: ServiceError)
    func showVerificationResult(response: WithdrawVerificationResponse)
    func withdrawSuccessful()
    func resendingCodeSuccess()
}

protocol InteractorToEntityVerificationProtocol {
    func signupProcess(code: String,
                       email: String,
                       completionHandler: @escaping (Result<GenericResponse, ServiceError>) -> Void)
    func sendOTP(email: String,
                 completionHandler: @escaping (Result<GenericResponse, ServiceError>) -> Void)
    func login(username: String,
               password: String,
               emailCode: String,
               completionHandler: @escaping (Result<LoginModel, ServiceError>) -> Void)
    func getProfileInfo(completionHandler: @escaping (Result<ProfileInfo, ServiceError>) -> Void)
    func excuteVerifyCode(code: String, sessionId: String, type: AuthenticationMethod, completionHandler: @escaping (Result<WithdrawVerificationResponse, ServiceError>) -> Void)
    func excuteWithdraw(request: WithdrawRequest, completionHandler: @escaping (Result<WidthdrawResponse, ServiceError>) -> Void)
    func sendTFAEmail(sessionId: String, completionHandler: @escaping () -> Void)
    func sendTFASms(sessionId: String, completionHandler: @escaping () -> Void)
    func callTFAPhone(sessionId: String, completionHandler: @escaping () -> Void)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterVerificationProtocol {
    func navigateToTerms()
    func navigateToSignUpComplete()
    func navigateToHelpEmail()
    func popToRootView()
    func reLogin()
    func backToReviewWithdraw()
    func backToRegister()
}

