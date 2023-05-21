//
//  SignUpRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 22/08/2022.
//  
//

import Foundation
import UIKit

class SignUpRouter: PresenterToRouterSignUpProtocol {
    func showScreen(agreements: Agreements?) {
        let destinationVC = self.createModule(agreements: agreements)
        destinationVC.hidesBottomBarWhenPushed = true
        guard let rootViewController = UIApplication.shared.getTopViewController() else { return }
        rootViewController.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView(agreements: Agreements?) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule(agreements: agreements)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(agreements: Agreements?) -> UIViewController {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:SignUpViewController.self)
        
        let presenter: ViewToPresenterSignUpProtocol & InteractorToPresenterSignUpProtocol = SignUpPresenter()
        let entity: InteractorToEntitySignUpProtocol = SignUpEntity()
        
        viewController.presenter = presenter
        viewController.presenter?.agreements = agreements
        viewController.presenter?.router = SignUpRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = SignUpInteractor()
        viewController.presenter?.interactor?.entity = entity
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func navigateToLogin() {
        LoginRouter().showScreen()
    }
    
    func navigateToVerification(email: String, titleNavigation: String) {
        VerificationRouter().showScreen(email: email, type: .signUp, tfaState: nil, verificationType: .signup)
    }
    
    func pop() {
        UIViewController().getRootTabbarViewController().popViewController(animated: true)
    }
    
    func popToRootView() {
        guard let rootViewController = UIApplication.shared.getTopViewController() else { return }
        rootViewController.navigationController?.popToRootViewController(animated: true)
    }
}
