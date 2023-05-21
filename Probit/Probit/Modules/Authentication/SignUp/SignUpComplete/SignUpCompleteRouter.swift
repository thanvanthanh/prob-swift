//
//  SignUpCompleteRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 22/08/2022.
//  
//

import Foundation
import UIKit

class SignUpCompleteRouter: PresenterToRouterSignUpCompleteProtocol {
    func showScreen(type: CompleteType) {
        let destinationVC = self.createModule(type: type)
        destinationVC.hidesBottomBarWhenPushed = true
        UIViewController().getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView(type: CompleteType) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule(type: type)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(type: CompleteType) -> UIViewController {
        let storyboard = UIStoryboard(name: "SignUpComplete", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:SignUpCompleteViewController.self)
        
        let presenter: ViewToPresenterSignUpCompleteProtocol & InteractorToPresenterSignUpCompleteProtocol = SignUpCompletePresenter()
        
        viewController.completeType = type
        viewController.presenter = presenter
        viewController.presenter?.router = SignUpCompleteRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = SignUpCompleteInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
}
