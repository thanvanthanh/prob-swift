//
//  StakeHistoryRouter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 06/10/2565 BE.
//  
//

import Foundation
import UIKit

class StakeHistoryRouter: PresenterToRouterStakeHistoryProtocol {
    var interactorDetail: StakeDetailsInteractorProtocol
    init(interactorDetail: StakeDetailsInteractorProtocol) {
        self.interactorDetail = interactorDetail
    }
    
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
        let storyboard = UIStoryboard(name: "StakeHistory", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:StakeHistoryViewController.self)
        
        let presenter: ViewToPresenterStakeHistoryProtocol & InteractorToPresenterStakeHistoryProtocol = StakeHistoryPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = self
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = StakeHistoryInteractor(interactorDetail: interactorDetail)
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
