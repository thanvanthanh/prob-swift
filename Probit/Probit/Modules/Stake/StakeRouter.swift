//
//  StakeRouter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 22/09/2565 BE.
//  
//

import Foundation
import UIKit

class StakeRouter: PresenterToRouterStakeProtocol {
    func navigateToSearch(stakeList: [StakeEventModel]) {
        StakeSearchRouter().showScreen()
    }
    
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
        let storyboard = UIStoryboard(name: "Stake", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:StakeViewController.self)
        
        let presenter: ViewToPresenterStakeProtocol & InteractorToPresenterStakeProtocol = StakePresenter()
        viewController.presenter = presenter
        viewController.presenter?.router = StakeRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = StakeInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
