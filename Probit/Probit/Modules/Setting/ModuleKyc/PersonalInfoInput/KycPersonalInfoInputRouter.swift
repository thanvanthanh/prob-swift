//
//  KycPersonalInfoInputRouter.swift
//  Probit
//
//  Created by Bradley Hoang on 08/11/2022.
//  
//

import UIKit

class KycPersonalInfoInputRouter: PresenterToRouterKycPersonalInfoInputProtocol {
    func showScreen() {
        let destinationVC = createModule()
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = createModule()
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule() -> UIViewController {
        let storyboard = UIStoryboard(name: "KycPersonalInfoInput", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:KycPersonalInfoInputViewController.self)
        
        let presenter: ViewToPresenterKycPersonalInfoInputProtocol & InteractorToPresenterKycPersonalInfoInputProtocol = KycPersonalInfoInputPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = KycPersonalInfoInputRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = KycPersonalInfoInputInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
