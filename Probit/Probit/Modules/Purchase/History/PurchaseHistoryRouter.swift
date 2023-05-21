//
//  PurchaseHistoryRouter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 19/10/2565 BE.
//  
//

import Foundation
import UIKit

class PurchaseHistoryRouter: PresenterToRouterPurchaseHistoryProtocol {
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
        let storyboard = UIStoryboard(name: "PurchaseHistory", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:PurchaseHistoryViewController.self)
        
        let presenter: ViewToPresenterPurchaseHistoryProtocol & InteractorToPresenterPurchaseHistoryProtocol = PurchaseHistoryPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = PurchaseHistoryRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = PurchaseHistoryInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
