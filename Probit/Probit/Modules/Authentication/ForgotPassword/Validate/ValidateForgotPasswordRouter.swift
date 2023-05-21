//
//  ValidateForgotPasswordRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 05/09/2022.
//  
//

import Foundation
import UIKit

class ValidateForgotPasswordRouter: PresenterToRouterValidateForgotPasswordProtocol {
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
        let storyboard = UIStoryboard(name: "ValidateForgotPassword", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:ValidateForgotPasswordViewController.self)
        
        let presenter: ViewToPresenterValidateForgotPasswordProtocol & InteractorToPresenterValidateForgotPasswordProtocol = ValidateForgotPasswordPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = ValidateForgotPasswordRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = ValidateForgotPasswordInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.email = email
        
        return viewController
    }
    
    func navigateToComplete() {
        SignUpCompleteRouter().showScreen(type: .changePassword)
    }
}
