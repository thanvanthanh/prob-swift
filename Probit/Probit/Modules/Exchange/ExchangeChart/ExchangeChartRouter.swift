//
//  ExchangeChartRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 13/10/2022.
//  
//

import Foundation
import UIKit

class ExchangeChartRouter: PresenterToRouterExchangeChartProtocol {
    func showScreen(marketId: String? = nil, exchange: ExchangeTicker?) {
        let destinationVC = self.createModule(marketId: marketId, exchange: exchange)
        destinationVC.getRootViewController().navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    // MARK: Static methods
    func createModule(marketId: String? = nil, exchange: ExchangeTicker?) -> UIViewController {
        let storyboard = UIStoryboard(name: "ExchangeChart", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:ExchangeChartViewController.self)
        
        let presenter: ViewToPresenterExchangeChartProtocol & InteractorToPresenterExchangeChartProtocol = ExchangeChartPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = ExchangeChartRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = ExchangeChartInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.exchange = exchange
        viewController.presenter?.interactor?.marketId = marketId
        return viewController
    }
}
