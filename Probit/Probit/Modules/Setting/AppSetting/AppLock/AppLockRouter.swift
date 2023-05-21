//
//  AppLockRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 27/09/2022.
//  
//

import Foundation
import UIKit

class AppLockRouter: PresenterToRouterAppLockProtocol {
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
        let storyboard = UIStoryboard(name: "AppLock", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:AppLockViewController.self)
        
        let presenter: ViewToPresenterAppLockProtocol & InteractorToPresenterAppLockProtocol = AppLockPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = AppLockRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = AppLockInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func navigateToInputPin(type: InputPinType) {
        InputPinRouter().showScreen(type: type)
    }
}
