//
//  WithdrawDetailInteractor.swift
//  Probit
//
//  Created by Dang Nguyen on 28/10/2022.
//  
//

import Foundation

class WithdrawDetailInteractor: PresenterToInteractorWithdrawDetailProtocol {    
    
    // MARK: Properties
    var presenter: InteractorToPresenterWithdrawDetailProtocol?
    var transactionHistory: TransactionHistory = TransactionHistory()
    var currency: WalletCurrency = WalletCurrency()
    var type: String = ""
    var start: Date = Date().previousMonth
    var end: Date = Date()
    var explorerCore: [ExplorerCore] = []
    
    private var txIdUrl: String? {
        guard let txId = transactionHistory.hash,
              let platformId = transactionHistory.platform_id,
              let url = self.explorerCore.first(where: { $0.platformId?.lowercased() == platformId.lowercased()})?.txId
        else { return nil }
        let txUrl = url.replacingOccurrences(of: "${txId}", with: txId)
        return txUrl
    }
    
    func shouldOpenWebBroswer() -> Bool {
        return txIdUrl != nil
    }
    
    func getExplorerCoreDeposit() {
        DepositAPI.shared.getExplorerCore { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                self.explorerCore = response
                break
            case let .failure(error):
                print(error.localizedDescription)
                break
            }
            self.presenter?.loadDataCompleted()
        }
    }
    
    func getProcess() {
        guard let currencyId = currency.id else { return }
        HistoryAPI.shared.getTransactionHistory(startTime: start, endTime: end, currencyId:  currencyId, type: type, completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                guard let id = self.transactionHistory.id, let tran = data.data?.first(where: { $0.id == id}) else { return }
                self.transactionHistory = tran
            case let .failure(error):
                print(error.localizedDescription)
                break
            }
            self.presenter?.loadDataCompleted()
        })
    }

}
