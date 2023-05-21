//
//  ExchangeOrderBookRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 17/10/2022.
//  
//

import Foundation
import UIKit

class ExchangeOrderBookRouter: PresenterToRouterExchangeOrderBookProtocol {
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
        let storyboard = UIStoryboard(name: "ExchangeOrderBook", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:ExchangeOrderBookViewController.self)
        
        let presenter: ViewToPresenterExchangeOrderBookProtocol & InteractorToPresenterExchangeOrderBookProtocol = ExchangeOrderBookPresenter()
        let entity:  InteractorToEntityExchangeOrderBookProtocol = ExchangeOrderBookEntity()
        
        viewController.presenter = presenter
        viewController.presenter?.router = ExchangeOrderBookRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = ExchangeOrderBookInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.entity = entity
        viewController.presenter?.exchange = exchange
        
        return viewController
    }
}
