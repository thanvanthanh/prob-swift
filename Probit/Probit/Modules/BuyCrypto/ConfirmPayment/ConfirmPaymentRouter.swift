//
//  ConfirmPaymentRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 26/08/2022.
//  
//

import Foundation
import UIKit

class ConfirmPaymentRouter: PresenterToRouterConfirmPaymentProtocol {
    func showScreen(params: PamentChanelParameters,
                    receive: String,
                    exchange: String,
                    method: String) {
        let destinationVC = self.createModule(params: params,
                                              receive: receive,
                                              exchange: exchange,
                                              method: method)
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView(params: PamentChanelParameters,
                       receive: String,
                       exchange: String,
                       method: String) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule(params: params,
                                              receive: receive,
                                              exchange: exchange,
                                              method: method)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(params: PamentChanelParameters,
                      receive: String,
                      exchange: String,
                      method: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "ConfirmPayment", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:ConfirmPaymentViewController.self)
        
        let presenter: ViewToPresenterConfirmPaymentProtocol & InteractorToPresenterConfirmPaymentProtocol = ConfirmPaymentPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = ConfirmPaymentRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = ConfirmPaymentInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.paymentParams = params
        viewController.presenter?.receive = receive
        viewController.presenter?.interactor?.exchange = exchange
        viewController.presenter?.interactor?.method = method
        
        return viewController
    }
    
    func navigateToCryptoRedirected(params: PamentChanelParameters,
                                    receive: String,
                                    method: String) {
        CryptoRedirectedRouter().showScreen(params: params,
                                            receive: receive,
                                            method: method)
    }
}
