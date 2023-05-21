//
//  IntroduceRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 20/09/2022.
//  
//

import Foundation
import UIKit

class IntroduceRouter: PresenterToRouterIntroduceProtocol {
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
        let storyboard = UIStoryboard(name: "Introduce", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:IntroduceViewController.self)
        
        let presenter: ViewToPresenterIntroduceProtocol & InteractorToPresenterIntroduceProtocol = IntroducePresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = IntroduceRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = IntroduceInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func navigateToHome() {
        TabbarRouter().setupRootView()
    }
}
