//
//  ThirdPartyListRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/12/2022.
//  
//

import Foundation
import UIKit

class ThirdPartyListRouter: PresenterToRouterThirdPartyListProtocol {
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
        let storyboard = UIStoryboard(name: "ThirdPartyList", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:ThirdPartyListViewController.self)
        
        let presenter: ViewToPresenterThirdPartyListProtocol & InteractorToPresenterThirdPartyListProtocol = ThirdPartyListPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = ThirdPartyListRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = ThirdPartyListInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func navigateToDetail(html: String) {
        ThirdPartyDetailRouter().showScreen(html: html)
    }
}
