//
//  DepositDetailContract.swift
//  Probit
//
//  Created by Dang Nguyen on 28/10/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewDepositDetailProtocol {
    func setupTransaction(transaction: TransactionHistory)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterDepositDetailProtocol {
    var view: PresenterToViewDepositDetailProtocol? { get set }
    var interactor: PresenterToInteractorDepositDetailProtocol? { get set }
    var router: PresenterToRouterDepositDetailProtocol? { get set }
    var explorerCore: [ExplorerCore] { get }
    func setupTransaction()
    func loadTransactionDetail()
    func getExplorerCoreDeposit()
    func openWebBrowser()
    func shouldOpenWebBrowser() -> Bool
    func openAddressWebBrowser()
    func openTxidWebBrowser()
    func viewDidLoad()
    func viewWillDisappear()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorDepositDetailProtocol {
    var presenter: InteractorToPresenterDepositDetailProtocol? { get set }
    var transactionHistory: TransactionHistory { get set }
    var currency: WalletCurrency { get set }
    var type: String { get set }
    var start: Date { get set }
    var end: Date { get set }
    var transactionDetailUrl: String { get set }
    var explorerCore: [ExplorerCore] { get set }
    func loadTransactionDetail(id: String)
    func shouldOpenWebBroswer() -> Bool
    func getExplorerCoreDeposit()
    func getProcess()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterDepositDetailProtocol {
    func loadDataCompleted()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterDepositDetailProtocol {
}
