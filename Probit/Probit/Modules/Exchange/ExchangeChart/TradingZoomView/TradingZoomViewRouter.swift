//
//  TradingZoomViewRouter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 10/01/2566 BE.
//  
//

import Foundation
import UIKit

class TradingZoomViewRouter: PresenterToRouterTradingZoomViewProtocol {
    var exchange: ExchangeTicker
    init(exchange: ExchangeTicker) {
        self.exchange = exchange
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
        let storyboard = UIStoryboard(name: "TradingZoomView", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:TradingZoomViewViewController.self)
        
        let presenter: ViewToPresenterTradingZoomViewProtocol & InteractorToPresenterTradingZoomViewProtocol = TradingZoomViewPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = self
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = TradingZoomViewInteractor(exchange: exchange)
        viewController.presenter?.interactor?.presenter = presenter
        return viewController
    }
}
