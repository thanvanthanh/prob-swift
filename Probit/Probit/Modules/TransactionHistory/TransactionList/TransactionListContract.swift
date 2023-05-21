//
//  TransactionListContract.swift
//  Probit
//
//  Created by Dang Nguyen on 27/10/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewTransactionListProtocol {
    func hideLoading()
    func showLoading()
    func reloadView()
    func loadDataToView()
    func showError(error: ServiceError)
    func showSuccess(message: String)
    func updateTransactionStatus(transactionId: String)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterTransactionListProtocol {
    var view: PresenterToViewTransactionListProtocol? { get set }
    var interactor: PresenterToInteractorTransactionListProtocol? { get set }
    var router: PresenterToRouterTransactionListProtocol? { get set }
    func viewWillAppear()
    func gotoDatePicker(delegate: FilterSearchViewDelegate)
    func getTransactionHistory()
    func gotoDetailTransaction(transaction: TransactionHistory, currency: WalletCurrency)
    func cancelTransaction(transactionId: String)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorTransactionListProtocol {
    var presenter: InteractorToPresenterTransactionListProtocol? { get set }
    var transactionHistory: [TransactionHistory] { get }
    var startTime: Date { get set }
    var endTime: Date { get set }
    var currency: WalletCurrency { get set }
    var type: String { get set }
    var filterModel: SearchFilterModel { get set}
    func cancelTransaction(transactionId: String)
    func getData()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterTransactionListProtocol {
    func handerApiError(error: ServiceError)
    func loadingSuccessful()
    func cancelTransactionSuccessful(transactionId: String)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterTransactionListProtocol {
    func gotoDatePicker(delegate: FilterSearchViewDelegate)
    func gotoWithdrawDetail(transaction: TransactionHistory, currency: WalletCurrency)
    func gotoDepositDetail(transaction: TransactionHistory, currency: WalletCurrency, type: String, start: Date, end: Date)
}
