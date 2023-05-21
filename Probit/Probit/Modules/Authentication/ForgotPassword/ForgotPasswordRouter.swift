//
//  ForgotPasswordRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 23/08/2022.
//  
//

import Foundation
import UIKit

class ForgotPasswordRouter: PresenterToRouterForgotPasswordProtocol {
    func showScreen() {
        let destinationVC = self.createModule()
        destinationVC.hidesBottomBarWhenPushed = true
        guard let rootViewController = UIApplication.shared.getTopViewController() else { return }
        rootViewController.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule()
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule() -> UIViewController {
        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:ForgotPasswordViewController.self)
        
        let presenter: ViewToPresenterForgotPasswordProtocol & InteractorToPresenterForgotPasswordProtocol = ForgotPasswordPresenter()
        let entity: InteractorToEntityForgotPasswordProtocol = ForgotPasswordEntity()

        
        viewController.presenter = presenter
        viewController.presenter?.router = ForgotPasswordRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = ForgotPasswordInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.entity = entity
        
        return viewController
    }
    
    func navigateToVerification(with email: String) {
        ForgotPasswordVerificationRouter().showScreen(email: email)
    }
    
    func popToTermScreen() {
        LoginRouter().forgotPasswordToTerm()
    }
}
