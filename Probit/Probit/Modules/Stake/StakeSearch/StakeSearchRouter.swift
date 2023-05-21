//
//  StakeSearchRouter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 23/09/2565 BE.
//  
//

import Foundation
import UIKit

class StakeSearchRouter: PresenterToRouterStakeSearchProtocol {
    func showScreen() {
        let destinationVC = self.createModule()
        destinationVC.getRootTabbarViewController().push(viewController: destinationVC, ishidesBottomBar: true)
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
        let storyboard = UIStoryboard(name: "StakeSearch", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:StakeSearchViewController.self)
        
        let presenter: ViewToPresenterStakeSearchProtocol & InteractorToPresenterStakeSearchProtocol = StakeSearchPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = self
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = StakeSearchInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
