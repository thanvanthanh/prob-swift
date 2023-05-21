//
//  ForgotPasswordVerificationRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 05/09/2022.
//  
//

import Foundation
import UIKit

class ForgotPasswordVerificationRouter: PresenterToRouterForgotPasswordVerificationProtocol {
    func showScreen(email: String) {
        let destinationVC = self.createModule(email: email)
        destinationVC.hidesBottomBarWhenPushed = true
        guard let rootNavigation = UIApplication.shared.getTopViewController() else { return }
        rootNavigation.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView(email: String) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule(email: email)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(email: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "ForgotPasswordVerification", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:ForgotPasswordVerificationViewController.self)
        
        let presenter: ViewToPresenterForgotPasswordVerificationProtocol & InteractorToPresenterForgotPasswordVerificationProtocol = ForgotPasswordVerificationPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = ForgotPasswordVerificationRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = ForgotPasswordVerificationInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.email = email
        
        return viewController
    }
    
    func navigateToValidateForgotPassword(with email: String) {
        ValidateForgotPasswordRouter().showScreen(email: email)
    }
    
    func popToPreviousView(from vc: UIViewController) {
        vc.pop()
    }
}
