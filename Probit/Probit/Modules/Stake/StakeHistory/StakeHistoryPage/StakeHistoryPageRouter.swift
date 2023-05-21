//
//  StakeHistoryPageRouter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 06/10/2565 BE.
//  
//

import Foundation
import UIKit

class StakeHistoryPageRouter: PresenterToRouterStakeHistoryPageProtocol {
    var stakeType: StakeType?
    
    init(stakeType: StakeType?) {
        self.stakeType = stakeType
    }
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
        let storyboard = UIStoryboard(name: "StakeHistoryPage", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:StakeHistoryPageViewController.self)
        let presenter: ViewToPresenterStakeHistoryPageProtocol & InteractorToPresenterStakeHistoryPageProtocol = StakeHistoryPagePresenter()
        viewController.stakeType = self.stakeType
        viewController.presenter = presenter
        viewController.presenter?.router = self
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = StakeHistoryPageInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
