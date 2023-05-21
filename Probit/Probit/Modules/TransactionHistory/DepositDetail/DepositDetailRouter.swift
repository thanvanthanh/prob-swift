//
//  DepositDetailRouter.swift
//  Probit
//
//  Created by Dang Nguyen on 28/10/2022.
//  
//

import Foundation
import UIKit

class DepositDetailRouter: PresenterToRouterDepositDetailProtocol {
    func showScreen(transaction: TransactionHistory, currency: WalletCurrency, type: String, start: Date, end: Date) {
        let destinationVC = self.createModule(transaction: transaction, currency: currency, type: type, start: start, end: end)
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView(transaction: TransactionHistory, currency: WalletCurrency, type: String, start: Date, end: Date) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule(transaction: transaction, currency: currency, type: type, start: start, end: end)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(transaction: TransactionHistory, currency: WalletCurrency, type: String, start: Date, end: Date) -> UIViewController {
        let storyboard = UIStoryboard(name: "DepositDetail", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:DepositDetailViewController.self)
        
        let presenter: ViewToPresenterDepositDetailProtocol & InteractorToPresenterDepositDetailProtocol = DepositDetailPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = DepositDetailRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = DepositDetailInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.transactionHistory = transaction
        viewController.presenter?.interactor?.currency = currency

        return viewController
    }
}
