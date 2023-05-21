//
//  WithdrawDetailContract.swift
//  Probit
//
//  Created by Dang Nguyen on 28/10/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewWithdrawDetailProtocol {
    func setupTransaction(transaction: TransactionHistory)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterWithdrawDetailProtocol {
    var view: PresenterToViewWithdrawDetailProtocol? { get set }
    var interactor: PresenterToInteractorWithdrawDetailProtocol? { get set }
    var router: PresenterToRouterWithdrawDetailProtocol? { get set }
    func setupTransaction()
    func viewDidLoad()
    func viewWillDisappear()
    func shouldOpenWebBrowser() -> Bool
    func openAddressWebBrowser(address: String)
    func openTxidWebBrowser(txid: String)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorWithdrawDetailProtocol {
    var presenter: InteractorToPresenterWithdrawDetailProtocol? { get set }
    var transactionHistory: TransactionHistory { get set }
    var currency: WalletCurrency { get set }
    var explorerCore: [ExplorerCore] { get set }
    var type: String { get set }
    var start: Date { get set }
    var end: Date { get set }
    func shouldOpenWebBroswer() -> Bool
    func getExplorerCoreDeposit()
    func getProcess()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterWithdrawDetailProtocol {
    func loadDataCompleted()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterWithdrawDetailProtocol {
}
