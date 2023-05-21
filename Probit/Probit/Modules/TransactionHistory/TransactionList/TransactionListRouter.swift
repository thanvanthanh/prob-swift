//
//  TransactionListRouter.swift
//  Probit
//
//  Created by Dang Nguyen on 27/10/2022.
//  
//

import Foundation
import UIKit

class TransactionListRouter: PresenterToRouterTransactionListProtocol {
    func gotoDatePicker(delegate: FilterSearchViewDelegate) {
        FillterHistoryRouter(delegate: delegate).showScreen(isHideCurrency: true)
    }

    func gotoWithdrawDetail(transaction: TransactionHistory, currency: WalletCurrency) {
        WithdrawDetailRouter().showScreen(transaction: transaction, currency: currency)
    }
    
    func gotoDepositDetail(transaction: TransactionHistory, currency: WalletCurrency, type: String, start: Date, end: Date) {
        DepositDetailRouter().showScreen(transaction: transaction, currency: currency, type: type, start: start, end: end)
    }
    
    func showScreen(currency: WalletCurrency, type: TransactionType) {
        let destinationVC = self.createModule(currency: currency, type: type)
        destinationVC.getRootViewController().navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView(currency: WalletCurrency, type: TransactionType) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule(currency: currency, type: type)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(currency: WalletCurrency, type: TransactionType) -> UIViewController {
        let storyboard = UIStoryboard(name: "TransactionList", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:TransactionListViewController.self)
        
        let presenter: ViewToPresenterTransactionListProtocol & InteractorToPresenterTransactionListProtocol = TransactionListPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = TransactionListRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = TransactionListInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.currency = currency
        viewController.presenter?.interactor?.type = type.rawValue

        return viewController
    }
}
