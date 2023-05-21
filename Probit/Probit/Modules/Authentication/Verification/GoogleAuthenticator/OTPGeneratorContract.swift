//
//  OTPGeneratorContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 06/09/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewOTPGeneratorProtocol: BaseViewProtocol {
    func navigateToHome()
    func otpInvalid(error: ServiceError)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterOTPGeneratorProtocol {
    var email: String? { get set }
    var password: String? { get set }
    var type: AuthScreenFrom? { get set }
    var loginResponse: LoginModel? { get }
    var view: PresenterToViewOTPGeneratorProtocol? { get set }
    var interactor: PresenterToInteractorOTPGeneratorProtocol? { get set }
    var router: PresenterToRouterOTPGeneratorProtocol? { get set }
    func login(totp: String)
    func navigateToLogin()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorOTPGeneratorProtocol {
    var loginResponse: LoginModel? { get set }
    var presenter: InteractorToPresenterOTPGeneratorProtocol? { get set }
    var entity: InteractorToEntityOTPGeneratorProtocol? { get set }
    func login(username: String,
               password: String,
               totp: String)
    func getProfileInfo()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterOTPGeneratorProtocol {
    func loginComplete(email: String, password: String)
    func getProfileInfoComplete(isShowTermScreen: Bool)
    func handerApiError(error: ServiceError)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterOTPGeneratorProtocol {
    func navigateToVerification(email: String, password: String)
    func navigateToTerms()
    func navigateToLogin()
}

protocol InteractorToEntityOTPGeneratorProtocol {
    func login(username: String,
               password: String,
               totp: String,
               completionHandler: @escaping (Result<LoginModel, ServiceError>) -> Void)
    func getProfileInfo(completionHandler: @escaping (Result<ProfileInfo, ServiceError>) -> Void)
}
