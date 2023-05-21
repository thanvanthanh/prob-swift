//
//  OTPGeneratorRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 06/09/2022.
//  
//

import Foundation
import UIKit

class OTPGeneratorRouter: PresenterToRouterOTPGeneratorProtocol {
    func showScreen(email: String?, password: String?, delegate: LoginViewControllerDelegate?) {
        let destinationVC = self.createModule(email: email, password: password, delegate: delegate)
        destinationVC.hidesBottomBarWhenPushed = true
        UIViewController().getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule(email: nil, password: nil, delegate: nil)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(email: String?, password: String?, delegate: LoginViewControllerDelegate?) -> UIViewController {
        let storyboard = UIStoryboard(name: "OTPGenerator", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:OTPGeneratorViewController.self)
        
        let presenter: ViewToPresenterOTPGeneratorProtocol & InteractorToPresenterOTPGeneratorProtocol = OTPGeneratorPresenter()
        let entity: InteractorToEntityOTPGeneratorProtocol = OTPGeneratorEntity()
        viewController.presenter = presenter
        viewController.presenter?.email = email
        viewController.presenter?.password = password
        viewController.presenter?.router = OTPGeneratorRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = OTPGeneratorInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.entity = entity
        viewController.delegate = delegate
        
        return viewController
    }
    
    func navigateToVerification(email: String, password: String) {
        VerificationRouter().showScreen(email: email, password: password, type: .signIn, tfaState: nil)
    }
    
    func navigateToTerms() {
        TermsRouter().showScreen(animated: true, screenFrom: .signIn)
    }
    
    func navigateToLogin() {
        guard let rootViewController = UIApplication.shared.getTopViewController() else { return }
        rootViewController.navigationController?.popToRootViewController(animated: true)
    }
}
