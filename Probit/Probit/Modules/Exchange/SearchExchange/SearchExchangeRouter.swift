//
//  SearchExchangeRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 16/10/2022.
//  
//

import Foundation
import UIKit

class SearchExchangeRouter: PresenterToRouterSearchExchangeProtocol {
    func showScreen(data: [ExchangeTicker]) {
        let destinationVC = self.createModule(data: data)
        destinationVC.getRootTabbarViewController().push(viewController: destinationVC)
    }
    
    func showScreen(keyword: String) {
        let destinationVC = createModule(keyword: keyword)
        destinationVC.getRootTabbarViewController().push(viewController: destinationVC)
    }
    
    func setupRootView() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule()
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(data: [ExchangeTicker] = [], keyword: String = "") -> UIViewController {
        let coins: [ExchangeTicker] = data.sorted { lhs, rhs in
            lhs.displayName.value < rhs.displayName.value
        }
        let storyboard = UIStoryboard(name: "SearchExchange", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:SearchExchangeViewController.self)
        
        let presenter: ViewToPresenterSearchExchangeProtocol & InteractorToPresenterSearchExchangeProtocol = SearchExchangePresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = SearchExchangeRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = SearchExchangeInteractor()
        viewController.presenter?.interactor?.coins = coins
        viewController.presenter?.interactor?.keyword = keyword
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func navigateToExchangeDetail(exchange: ExchangeTicker?) {
        ExchangeDetailRouter().showScreen(exchange: exchange)
    }
}
