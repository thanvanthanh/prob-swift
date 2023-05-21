//
//  KycAddressInputRouter.swift
//  Probit
//
//  Created by Bradley Hoang on 09/11/2022.
//  
//

import UIKit

class KycAddressInputRouter: PresenterToRouterKycAddressInputProtocol {
    func showScreen() {
        let destinationVC = createModule()
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appDelegate.window else { return }
        
        let destinationVC = createModule()
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule() -> UIViewController {
        let storyboard = UIStoryboard(name: "KycAddressInput", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:KycAddressInputViewController.self)
        
        let presenter: ViewToPresenterKycAddressInputProtocol & InteractorToPresenterKycAddressInputProtocol = KycAddressInputPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = KycAddressInputRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = KycAddressInputInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
