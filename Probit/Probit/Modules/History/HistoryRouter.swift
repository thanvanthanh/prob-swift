//
//  HistoryRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 29/08/2022.
//  
//

import Foundation
import UIKit

class HistoryRouter: PresenterToRouterHistoryProtocol {
    func showScreen() {
        let destinationVC = self.createModule()
        destinationVC.getRootTabbarViewController().navigationController?.pushViewController(destinationVC, animated: true)
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
        let storyboard = UIStoryboard(name: "History", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:HistoryViewController.self)
        
        let presenter: ViewToPresenterHistoryProtocol & InteractorToPresenterHistoryProtocol = HistoryPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = HistoryRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = HistoryInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
