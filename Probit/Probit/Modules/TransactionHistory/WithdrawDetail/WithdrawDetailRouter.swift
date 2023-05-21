//
//  WithdrawDetailRouter.swift
//  Probit
//
//  Created by Dang Nguyen on 28/10/2022.
//  
//

import Foundation
import UIKit

class WithdrawDetailRouter: PresenterToRouterWithdrawDetailProtocol {
    func showScreen(transaction: TransactionHistory, currency: WalletCurrency) {
        let destinationVC = self.createModule(transaction: transaction, currency: currency)
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView(transaction: TransactionHistory, currency: WalletCurrency) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule(transaction: transaction, currency: currency)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(transaction: TransactionHistory, currency: WalletCurrency) -> UIViewController {
        let storyboard = UIStoryboard(name: "WithdrawDetail", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:WithdrawDetailViewController.self)
        
        let presenter: ViewToPresenterWithdrawDetailProtocol & InteractorToPresenterWithdrawDetailProtocol = WithdrawDetailPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = WithdrawDetailRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = WithdrawDetailInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.transactionHistory = transaction
        viewController.presenter?.interactor?.currency = currency
        return viewController
    }
}
