//
//  ExchangePageViewRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 26/08/2022.
//  
//

import Foundation
import UIKit

class ExchangePageViewRouter: PresenterToRouterExchangePageViewProtocol {
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
        let storyboard = UIStoryboard(name: "ExchangePageView", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:ExchangePageViewViewController.self)
        
        let presenter: ViewToPresenterExchangePageViewProtocol & InteractorToPresenterExchangePageViewProtocol = ExchangePageViewPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = ExchangePageViewRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = ExchangePageViewInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func navigateToExchangeDetail(exchange: ExchangeTicker?) {
        ExchangeDetailRouter().showScreen(exchange: exchange)
    }
}
