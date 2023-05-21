//
//  VerificationRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 22/08/2022.
//  
//

import Foundation
import UIKit

class VerificationRouter: PresenterToRouterVerificationProtocol {
    func showScreen(email: String,
                    password: String? = nil,
                    type: AuthScreenFrom,
                    tfaState: TFAState?,
                    verificationType: AuthenticationMethod = .email,
                    withdrawRequest: WithdrawRequest? = nil) {
        let destinationVC = self.createModule(email: email,
                                              password: password,
                                              type: type,
                                              verificationType: verificationType,
                                              tfaState: tfaState,
                                              withdrawRequest: withdrawRequest)
        guard let rootViewController = UIApplication.shared.getTopViewController() else { return }
        destinationVC.hidesBottomBarWhenPushed = true
        rootViewController.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    // MARK: Static methods
    func createModule(email: String,
                      password: String?,
                      type: AuthScreenFrom,
                      verificationType: AuthenticationMethod,
                      tfaState: TFAState?,
                      withdrawRequest: WithdrawRequest? = nil) -> UIViewController {
        let storyboard = UIStoryboard(name: "Verification", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:VerificationViewController.self)
        
        let presenter: ViewToPresenterVerificationProtocol & InteractorToPresenterVerificationProtocol = VerificationPresenter()
        let entity: InteractorToEntityVerificationProtocol = VerificationEntity()
        
        viewController.presenter = presenter
        viewController.presenter?.router = VerificationRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = VerificationInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.email = email
        viewController.presenter?.type = type
        viewController.presenter?.password = password
        viewController.presenter?.interactor?.entity = entity
        viewController.presenter?.interactor?.tfaState = tfaState
        viewController.presenter?.interactor?.withdrawRequest = withdrawRequest
        viewController.presenter?.interactor?.type = verificationType

        return viewController
    }
    
    func navigateToTerms() {
        TermsRouter().showScreen(animated: true, screenFrom: .signIn)
    }
    
    func navigateToSignUpComplete() {
        SignUpCompleteRouter().showScreen(type: .signUp)
    }
    
    func navigateToHelpEmail() {
        CommonWebViewRouter().showScreen(titleBackScreen: "activity_verification_title".Localizable(),
                                         urlString: AppConstant.Link.helpEmail,
                                         html: nil,
                                         titleNavigation: "ProBit Global")
    }
    
    func popToRootView() {
        UIViewController().getRootTabbarViewController().popToRootViewController(animated: false)
    }
    
    func reLogin() {
        guard let loginViewController = UIViewController().getRootTabbarViewController().viewControllers.first(where: {$0.className == LoginViewController.className}) else { return }
        UIViewController().getRootTabbarViewController().popToViewController(loginViewController, animated: true)
    }
    
    func backToRegister() {
        UIViewController().getRootTabbarViewController().popViewController(animated: true)
    }
    
    func backToReviewWithdraw() {
        UIViewController().getRootTabbarViewController().popToViewController(ofClass: WithdrawReviewViewController.self)
    }
}
