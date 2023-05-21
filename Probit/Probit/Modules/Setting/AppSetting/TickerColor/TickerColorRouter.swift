//
//  TickerColorRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//  
//

import Foundation
import UIKit

class TickerColorRouter: PresenterToRouterTickerColorProtocol {
    func showScreen(delegate: TickerColorDelegate? = nil,
                    tickerColor: TickerColor) {
        let destinationVC = self.createModule(delegate: delegate, tickerColor: tickerColor)
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
    func createModule(delegate: TickerColorDelegate? = nil, tickerColor: TickerColor? = nil) -> UIViewController {
        let storyboard = UIStoryboard(name: "TickerColor", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:TickerColorViewController.self)
        
        let presenter: ViewToPresenterTickerColorProtocol & InteractorToPresenterTickerColorProtocol = TickerColorPresenter(delegate: delegate)
        
        viewController.presenter = presenter
        viewController.presenter?.router = TickerColorRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = TickerColorInteractor(tickerColor: tickerColor ?? .option1)
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
}
