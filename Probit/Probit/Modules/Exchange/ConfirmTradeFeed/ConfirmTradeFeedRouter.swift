//
//  ConfirmTradeFeedRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 25/10/2022.
//  
//

import Foundation
import UIKit

class ConfirmTradeFeedRouter: PresenterToRouterConfirmTradeFeedProtocol {
    
    func showScreen(orderSide: OrderSide, data: ConfirmTradeFeed, delegate: ConfirmTradeFeedProtocol?) {
        let destinationVC = self.createModule(orderSide: orderSide, data: data, delegate: delegate)
        destinationVC.modalPresentationStyle = .overFullScreen
        destinationVC.modalTransitionStyle = .crossDissolve
        destinationVC.getRootTabbarViewController().present(destinationVC, animated: true)
    }
    
    func setupRootView(data: ConfirmTradeFeed) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule(data: data, delegate: nil)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    // MARK: Static methods
    func createModule(orderSide: OrderSide = .BUY,
                      data: ConfirmTradeFeed,
                      delegate: ConfirmTradeFeedProtocol?) -> UIViewController {
        let storyboard = UIStoryboard(name: "ConfirmTradeFeed", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:ConfirmTradeFeedViewController.self)
        
        let presenter: ViewToPresenterConfirmTradeFeedProtocol & InteractorToPresenterConfirmTradeFeedProtocol = ConfirmTradeFeedPresenter(delegate: delegate)
        
        viewController.presenter = presenter
        viewController.presenter?.router = ConfirmTradeFeedRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = ConfirmTradeFeedInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.marketId = data.marketId
        viewController.presenter?.orderPrice = data.orderPrice
        viewController.presenter?.orderAmount = data.orderAmount
        viewController.presenter?.totalOrder = data.totalOrder
        viewController.presenter?.orderSide = orderSide
        
        return viewController
    }
}
