//
//  TradeFeedDetailRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 21/10/2022.
//  
//

import Foundation
import UIKit

class TradeFeedDetailRouter: PresenterToRouterTradeFeedDetailProtocol {
    func showScreen(exchange: ExchangeTicker?, orderBooks: [[OrderBook]], orderSide: OrderSide) {
        let destinationVC = self.createModule(exchange: exchange, orderBooks: orderBooks, orderSide: orderSide)
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
    func createModule(exchange: ExchangeTicker? = nil,
                      orderBooks: [[OrderBook]] = [],
                      orderSide: OrderSide = .BUY) -> UIViewController {
        let storyboard = UIStoryboard(name: "TradeFeedDetail", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:TradeFeedDetailViewController.self)
        
        let presenter: ViewToPresenterTradeFeedDetailProtocol & InteractorToPresenterTradeFeedDetailProtocol = TradeFeedDetailPresenter()
        let entity: InteractorToEntityTradeFeedDetailProtocol = TradeFeedDetailEntity()
        
        viewController.presenter = presenter
        viewController.presenter?.router = TradeFeedDetailRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = TradeFeedDetailInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.entity = entity
        viewController.presenter?.exchange = exchange
        viewController.presenter?.orderBooks = orderBooks
        viewController.presenter?.orderSide = orderSide
        
        return viewController
    }
    
    func showPopUpConfirm(orderSide: OrderSide,
                          data: ConfirmTradeFeed,
                          delegate: ConfirmTradeFeedProtocol?) {
        ConfirmTradeFeedRouter().showScreen(orderSide: orderSide, data: data, delegate: delegate)
    }
    
    func showOpenOrders(pair: String, delegate: OpenOrdersDelegate?) {
        OpenOrdersRouter().pushScreen(type: .bottomSheet, pair: pair, delegate: delegate)
    }
}
