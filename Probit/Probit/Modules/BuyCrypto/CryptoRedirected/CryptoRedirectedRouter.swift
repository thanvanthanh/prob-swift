//
//  CryptoRedirectedRouter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 26/08/2022.
//  
//

import Foundation
import UIKit

class CryptoRedirectedRouter: PresenterToRouterCryptoRedirectedProtocol {
    func showScreen(params: PamentChanelParameters,
                    receive: String,
                    method: String) {
        let destinationVC = self.createModule(params: params,
                                              receive: receive,
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
                                              method: method)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(params: PamentChanelParameters,
                      receive: String,
                      method: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "CryptoRedirected", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:CryptoRedirectedViewController.self)
        
        let presenter: ViewToPresenterCryptoRedirectedProtocol & InteractorToPresenterCryptoRedirectedProtocol = CryptoRedirectedPresenter()
        let entity: InteractorToEntityCryptoRedirectedProtocol = CryptoRedirectedEntity()
        
        viewController.presenter = presenter
        viewController.presenter?.router = CryptoRedirectedRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = CryptoRedirectedInteractor()
        viewController.presenter?.interactor?.entity = entity
        viewController.presenter?.interactor?.params = params
        viewController.presenter?.interactor?.method = method
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
 
    func navigateToPaymentWebView(url: String) {
        guard let urls = URL(string: url) else { return }
        UIApplication.shared.open(urls)
    }
    
    func navigateToWallet(currency: WalletCurrency) {
        guard let firstViewController = UIViewController().getRootTabbarViewController().viewControllers.first else { return }
        TransactionHistoryRouter().showScreen(currency: currency)
        guard let currentViewController = UIViewController().getRootTabbarViewController().viewControllers.last else { return }
        UIViewController().getRootTabbarViewController().viewControllers = [firstViewController, currentViewController]
    }
}
