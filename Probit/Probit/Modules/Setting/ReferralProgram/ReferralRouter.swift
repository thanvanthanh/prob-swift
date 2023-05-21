//
//  ReferralRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 29/08/2022.
//  
//

import Foundation
import UIKit

class ReferralRouter: PresenterToRouterReferralProtocol {
    func showScreen() {
        let destinationVC = self.createModule()
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    func addReferralToNavigationStack() {
        let destinationVC = self.createModule()
        destinationVC.getRootTabbarViewController().viewControllers.append(destinationVC)
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
        let storyboard = UIStoryboard(name: "Referral", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:ReferralViewController.self)
        
        let presenter: ViewToPresenterReferralProtocol & InteractorToPresenterReferralProtocol = ReferralPresenter()
        let entity: InteractorToEntityReferralProtocol = ReferralEntity()
        
        viewController.hidesBottomBarWhenPushed = true
        viewController.presenter = presenter
        viewController.presenter?.router = ReferralRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = ReferralInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.entity = entity
        
        return viewController
    }
    
}
