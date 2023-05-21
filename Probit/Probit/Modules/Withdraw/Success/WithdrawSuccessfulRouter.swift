//
//  WithdrawSuccessfulRouter.swift
//  Probit
//
//  Created by Dang Nguyen on 10/11/2022.
//  
//

import Foundation
import UIKit

class WithdrawSuccessfulRouter: PresenterToRouterWithdrawSuccessfulProtocol {
    func gotoWallet() {
        UIViewController().getRootTabbarViewController().viewControllers.last?.navigationController?.popToRootViewController(animated: true)
    }
    
    func showScreen() {
        let destinationVC = self.createModule()
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
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
        let storyboard = UIStoryboard(name: "WithdrawSuccessful", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:WithdrawSuccessfulViewController.self)
        
        let presenter: ViewToPresenterWithdrawSuccessfulProtocol & InteractorToPresenterWithdrawSuccessfulProtocol = WithdrawSuccessfulPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = WithdrawSuccessfulRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = WithdrawSuccessfulInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
