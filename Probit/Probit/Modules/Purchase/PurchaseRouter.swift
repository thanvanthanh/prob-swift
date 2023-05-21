//
//  PurchaseRouter.swift
//  Probit
//
//  Created by Bradley Hoang on 27/09/2022.
//  
//

import UIKit

final class PurchaseRouter: PresenterToRouterPurchaseProtocol {
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
        let storyboard = UIStoryboard(name: "Purchase", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType: PurchaseViewController.self)
        
        let presenter: ViewToPresenterPurchaseProtocol & InteractorToPresenterPurchaseProtocol = PurchasePresenter()
        
        viewController.hidesBottomBarWhenPushed = true
        viewController.presenter = presenter
        viewController.presenter?.router = PurchaseRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = PurchaseInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
