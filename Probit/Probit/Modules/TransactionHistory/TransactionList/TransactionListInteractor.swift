//
//  TransactionListInteractor.swift
//  Probit
//
//  Created by Dang Nguyen on 27/10/2022.
//  
//

import Foundation

class TransactionListInteractor: PresenterToInteractorTransactionListProtocol {
    
    // MARK: Properties
    var presenter: InteractorToPresenterTransactionListProtocol?
    var transactionHistory: [TransactionHistory] = []
    var startTime: Date = Date().previousMonth
    var endTime: Date = Date()
    var currency: WalletCurrency = WalletCurrency()
    var type: String = ""

    var filterModel: SearchFilterModel = {
        var defaultFilterModel = SearchFilterModel.init(limit: 100)
        defaultFilterModel.startTime = Date().previousMonth
        defaultFilterModel.endTime = Date()
        return defaultFilterModel
    }()

    func getData() {
        guard let currencyId = currency.id else { return }
        HistoryAPI.shared.getTransactionHistory(startTime: startTime, endTime: endTime, currencyId:  currencyId, type: type, completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                self.transactionHistory = data.data ?? []
                self.presenter?.loadingSuccessful()
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
                break
            }
        })
    }
    
    func cancelTransaction(transactionId: String) {
        HistoryAPI.shared.cancelRequest(transactionId: transactionId, completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(_):                
                self.presenter?.cancelTransactionSuccessful(transactionId: transactionId)
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
                break
            }
        })
    }
}
