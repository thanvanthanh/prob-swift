//
//  ExchangeTradeFeedRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 17/10/2022.
//  
//

import Foundation
import UIKit

class ExchangeTradeFeedRouter: PresenterToRouterExchangeTradeFeedProtocol {
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
    func createModule(exchange: ExchangeTicker? = nil) -> UIViewController {
        let storyboard = UIStoryboard(name: "ExchangeTradeFeed", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:ExchangeTradeFeedViewController.self)
        
        let presenter: ViewToPresenterExchangeTradeFeedProtocol & InteractorToPresenterExchangeTradeFeedProtocol = ExchangeTradeFeedPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = ExchangeTradeFeedRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = ExchangeTradeFeedInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.exchange = exchange
        return viewController
    }
}
