//
//  LoginRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 22/08/2022.
//  
//

import Foundation
import UIKit

enum LoginType {
    case inputPin
    case normal
}

class LoginRouter: PresenterToRouterLoginProtocol {
    
    var delegate: LoginViewControllerDelegate?
    
    init(delegate: LoginViewControllerDelegate? = nil) {
        self.delegate = delegate
    }
    
    func showScreen(type: LoginType = .normal, requestType: RequestType = .normal) {
        let destinationVC = self.createModule(type: type, requestType: requestType)
        destinationVC.hidesBottomBarWhenPushed = true
        UIViewController().getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    func addLoginToNavigationStack(type: LoginType = .normal) {
        let destinationVC = self.createModule(type: type)
        UIViewController().getRootTabbarViewController().viewControllers.append(destinationVC)
    }
    
    func dismiss() {
        if let loginViewController =  UIViewController().getRootTabbarViewController().viewControllers.last {
            loginViewController.navigationController?.popViewController(animated: true)
        } else {
            UIViewController().dismiss(animated: true)
        }
    }
    
    func setupRootView() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule()
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(type: LoginType? = .normal, requestType: RequestType = .normal) -> UIViewController {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:LoginViewController.self)
        
        let presenter: ViewToPresenterLoginProtocol & InteractorToPresenterLoginProtocol = LoginPresenter()
        let entity: InteractorToEntityLoginProtocol = LoginEntity()
        viewController.delegate = self.delegate
        viewController.presenter = presenter
        viewController.presenter?.router = self
        viewController.presenter?.view = viewController
        viewController.presenter?.requestType = requestType
        viewController.presenter?.interactor = LoginInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.entity = entity
        viewController.presenter?.type = type
        
        return viewController
    }
    
    func navigateToVerification(email: String, password: String, tfaState: TFAState?) {
        VerificationRouter().showScreen(email: email,
                                        password: password,
                                        type: .signIn, tfaState: tfaState)
    }
    
    func navigateToGoogleAuthentication(email: String, password: String) {
        OTPGeneratorRouter().showScreen(email: email, password: password, delegate: delegate)
    }
    
    func navigateToTerms(screenFrom: AuthScreenFrom) {
        TermsRouter().showScreen(animated: true, screenFrom: screenFrom)
    }
    
    func navigateToForgotPassword() {
        ForgotPasswordRouter().showScreen()
    }
    
    func navigateToU2F(argument: WithdrawVerificationArgument) {
        WithdrawVerificationRouter().showScreen(withArgument: argument)
    }
        
    func forgotPasswordToTerm() {
//        guard let navigation = UIApplication.shared.getTopViewController()?.navigationController else { return }
//        navigation.popToRootViewController(animated: false)
        TermsRouter().showScreen(animated: true, screenFrom: .signUp)
    }
}

class LoginNavigationController: UINavigationController {
    
}
