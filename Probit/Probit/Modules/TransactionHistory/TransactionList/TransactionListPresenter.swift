//
//  TransactionListPresenter.swift
//  Probit
//
//  Created by Dang Nguyen on 27/10/2022.
//  
//

import Foundation

class TransactionListPresenter: ViewToPresenterTransactionListProtocol {
    // MARK: Properties
    var view: PresenterToViewTransactionListProtocol?
    var interactor: PresenterToInteractorTransactionListProtocol?
    var router: PresenterToRouterTransactionListProtocol?

    func viewWillAppear() {
    }

    func gotoDatePicker(delegate: FilterSearchViewDelegate) {
        router?.gotoDatePicker(delegate: delegate)
    }
    
    func getTransactionHistory() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func cancelTransaction(transactionId: String) {
        view?.showLoading()
        interactor?.cancelTransaction(transactionId: transactionId)
    }
    
    func gotoDetailTransaction(transaction: TransactionHistory, currency: WalletCurrency) {
        guard let type = interactor?.type, let start = interactor?.startTime, let end = interactor?.endTime else { return }
        if transaction.type == TransactionType.deposit.rawValue {
            router?.gotoDepositDetail(transaction: transaction, currency: currency, type: type, start: start, end: end)
        } else {
            router?.gotoWithdrawDetail(transaction: transaction, currency: currency)
        }
    }
}

extension TransactionListPresenter: InteractorToPresenterTransactionListProtocol {
    func cancelTransactionSuccessful(transactionId: String) {
        view?.hideLoading()
        view?.updateTransactionStatus(transactionId: transactionId)
    }
    
    func handerApiError(error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
    
    func loadingSuccessful() {
        view?.hideLoading()
        view?.reloadView()
    }
}
