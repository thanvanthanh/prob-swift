//
//  ExchangeRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 25/08/2022.
//  
//

import Foundation
import UIKit

class ExchangeRouter: PresenterToRouterExchangeProtocol {
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
        let storyboard = UIStoryboard(name: "Exchange", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:ExchangeViewController.self)
        
        let presenter: ViewToPresenterExchangeProtocol & InteractorToPresenterExchangeProtocol = ExchangePresenter()
        let entity: InteractorToEntityExchangeProtocol = ExchangeEntity()
        viewController.presenter = presenter
        viewController.presenter?.router = ExchangeRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = ExchangeInteractor()
        viewController.presenter?.interactor?.entity = entity
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func navigateToSearchExchange(data: [ExchangeTicker]) {
        SearchExchangeRouter().showScreen(data: data)
    }
    
    func changeSelectedTabbar() {
        let destinationVC = self.createModule()
        destinationVC.getRootTabbarViewController().tabBarController?.selectedIndex = TabBarItem.exchange.rawIndex
    }
}
