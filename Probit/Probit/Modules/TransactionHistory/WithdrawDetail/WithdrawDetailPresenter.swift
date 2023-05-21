//
//  WithdrawDetailPresenter.swift
//  Probit
//
//  Created by Dang Nguyen on 28/10/2022.
//  
//

import Foundation

class WithdrawDetailPresenter: ViewToPresenterWithdrawDetailProtocol {
    // MARK: Properties
    var view: PresenterToViewWithdrawDetailProtocol?
    var interactor: PresenterToInteractorWithdrawDetailProtocol?
    var router: PresenterToRouterWithdrawDetailProtocol?
    var explorerCore: [ExplorerCore] { interactor?.explorerCore ?? [] }
    var timer: Timer?
    
    func viewDidLoad() {
        self.getExplorerCoreDeposit()
        guard let status = interactor?.transactionHistory.status else { return }
        if status != .canceled && status != .done {
            self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
        }
    }
    
    func viewWillDisappear() {
        self.destroyTimer()
    }
    
    func setupTransaction() {
        guard let transaction = interactor?.transactionHistory else { return }
        view?.setupTransaction(transaction: transaction)
        if let tranStatus = transaction.status, tranStatus == .canceled, tranStatus == .done {
            self.destroyTimer()
        }
    }
    
    private func destroyTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc
    func runTimer() {
        self.interactor?.getProcess()
    }
    
    func getExplorerCoreDeposit() {
        interactor?.getExplorerCoreDeposit()
    }
    
    func openAddressWebBrowser(address: String) {
        guard let transaction = interactor?.transactionHistory,
              let id = transaction.currency_id,
              let explorer = explorerCore.first(where: { $0.platformId?.uppercased() == id.uppercased() }),
              let urlString = explorer.address?.split(separator: "$").first,
              let url = URL(string: urlString + address)else { return }
        UIApplication.shared.open(url)
    }
    
    func openTxidWebBrowser(txid: String) {
        guard let transaction = interactor?.transactionHistory,
              let id = transaction.platform_id,
              let explorer = explorerCore.first(where: { $0.platformId?.uppercased() == id.uppercased() }),
              let urlString = explorer.txId?.split(separator: "$").first,
              let url = URL(string: urlString + txid)else { return }
        UIApplication.shared.open(url)
    }
    
    func shouldOpenWebBrowser() -> Bool {
        return interactor?.shouldOpenWebBroswer() ?? false
    }
    
}

extension WithdrawDetailPresenter: InteractorToPresenterWithdrawDetailProtocol {
    func loadDataCompleted() {
        self.setupTransaction()
    }
    
    
}
