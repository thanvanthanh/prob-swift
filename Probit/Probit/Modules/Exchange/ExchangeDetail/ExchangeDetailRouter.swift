//
//  ExchangeDetailRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 13/10/2022.
//  
//

import Foundation
import UIKit

class ExchangeDetailRouter: PresenterToRouterExchangeDetailProtocol {
    func showScreen(exchange: ExchangeTicker?) {
        let destinationVC = self.createModule(exchange: exchange)
        destinationVC.getRootTabbarViewController().push(viewController: destinationVC)
    }
    
    func showScreen(exchangeId: String?) {
        let destinationVC = self.createModule(exchange: nil, exchangeId: exchangeId)
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
    func createModule(exchange: ExchangeTicker? = nil, exchangeId: String? = nil) -> UIViewController {
        let storyboard = UIStoryboard(name: "ExchangeDetail", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:ExchangeDetailViewController.self)
        
        let presenter: ViewToPresenterExchangeDetailProtocol & InteractorToPresenterExchangeDetailProtocol = ExchangeDetailPresenter()
        let entity: InteractorToEntityExchangeDetailProtocol = ExchangeDetailEntity()

        viewController.presenter = presenter
        viewController.presenter?.router = ExchangeDetailRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = ExchangeDetailInteractor(exchange: exchange,
                                                                        exchangeId: exchangeId)
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.entity = entity

        return viewController
    }
    
    func navigationLogin() {
        LoginRouter().showScreen()
    }
    
    func navigationStaking() {
        PurchaseRouter().showScreen()
    }
    
    func navigationKycLevel(kycStatusModel: UserKycStatusDetailModel) {
        KycIntroduceRouter(kycStatusModel: kycStatusModel).showScreen(leftTitle: "navigationbar_market".Localizable())
    }
    
    func navigationToTradeFeedDetail(exchange: ExchangeTicker, orderBooks: [[OrderBook]], orderSide: OrderSide) {
        TradeFeedDetailRouter().showScreen(exchange: exchange, orderBooks: orderBooks, orderSide: orderSide)
    }
}
