//
//  WithdrawVerificationRouter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 01/12/2565 BE.
//  
//

import Foundation
import UIKit

typealias WithdrawVerificationPresenterInterface = ViewToPresenterWithdrawVerificationProtocol & InteractorToPresenterWithdrawVerificationProtocol

class WithdrawVerificationRouter: PresenterToRouterWithdrawVerificationProtocol {
    
    var delegate: LoginViewControllerDelegate?
    
    init(delegate: LoginViewControllerDelegate? = nil) {
        self.delegate = delegate
    }
    
    func showScreen(withArgument argument: WithdrawVerificationArgument) {
        let destinationVC = self.createModule(withArgument: argument)
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    func createModule(withArgument argument: WithdrawVerificationArgument) -> UIViewController {
        let storyboard = UIStoryboard(name: "WithdrawVerification", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:WithdrawVerificationViewController.self)
        
        let presenter: WithdrawVerificationPresenterInterface = WithdrawVerificationPresenter(with: argument)
        viewController.presenter = presenter
        viewController.delegate = self.delegate
        viewController.presenter?.router = self
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = WithdrawVerificationInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func navigateToVerification(email: String, password: String, tfaState: TFAState?) {
        VerificationRouter().showScreen(email: email,
                                        password: password,
                                        type: .signIn, tfaState: tfaState)
    }
    
    func navigateToTerms(screenFrom: AuthScreenFrom) {
        TermsRouter().showScreen(animated: true, screenFrom: screenFrom)
    }
    
    func navigateToGoogleAuthentication(email: String, password: String) {
        OTPGeneratorRouter().showScreen(email: email, password: password, delegate: delegate)
    }    
}
