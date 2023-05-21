//
//  SplashRouter.swift
//  Probit
//
//  Created by Beacon on 21/08/2022.
//  
//

import Foundation
import UIKit

class SplashRouter: PresenterToRouterSplashProtocol {
    func showScreen() {
        let destinationVC = self.createModule()
        destinationVC.getRootViewController().navigationController?.pushViewController(destinationVC, animated: true)
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
        let storyboard = UIStoryboard(name: "Splash", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType: SplashViewController.self)
        
        let presenter: ViewToPresenterSplashProtocol & InteractorToPresenterSplashProtocol = SplashPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = SplashRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = SplashInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func navigateToLogin() {
        TabbarRouter().setupRootView()
    }
    
}
