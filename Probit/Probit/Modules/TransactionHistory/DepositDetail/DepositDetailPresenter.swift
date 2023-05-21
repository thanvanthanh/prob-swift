//
//  DepositDetailPresenter.swift
//  Probit
//
//  Created by Dang Nguyen on 28/10/2022.
//  
//

import Foundation

class DepositDetailPresenter: ViewToPresenterDepositDetailProtocol {
    // MARK: Properties
    var view: PresenterToViewDepositDetailProtocol?
    var interactor: PresenterToInteractorDepositDetailProtocol?
    var router: PresenterToRouterDepositDetailProtocol?
    var explorerCore: [ExplorerCore] { interactor?.explorerCore ?? [] }
    
    var timer: Timer?
    
    func viewDidLoad() {
        guard let status = interactor?.transactionHistory.status else { return }
        if status != .canceled && status != .done {
            self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
        }
    }
    
    func viewWillDisappear() {
        self.destroyTimer()
    }
    
    private func destroyTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc
    func runTimer() {
        self.interactor?.getProcess()
    }
    
    func setupTransaction() {
        guard let transaction = interactor?.transactionHistory else { return }
        view?.setupTransaction(transaction: transaction)
        loadTransactionDetail()
    }
    
    func loadTransactionDetail() {
        guard let transaction = interactor?.transactionHistory, let id = transaction.id else { return }
        interactor?.loadTransactionDetail(id: id)
    }
    
    func getExplorerCoreDeposit() {
        interactor?.getExplorerCoreDeposit()
    }
    
    func openAddressWebBrowser() {
        if !(self.interactor?.transactionDetailUrl.isEmpty ?? false) {
            self.openWebBrowser()
        } else if let transaction = interactor?.transactionHistory,
                  let id = transaction.platform_id,
                  let explorer = explorerCore.first(where: { $0.platformId?.uppercased() == id.uppercased() }),
                  let urlString = explorer.address?.split(separator: "$").first,
                  let address = transaction.address,
                  let url = URL(string: urlString + address) {
            UIApplication.shared.open(url)
        } else { return }
    }
    
    func openTxidWebBrowser() {
        
        if !(self.interactor?.transactionDetailUrl.isEmpty ?? false) {
            self.openWebBrowser()
        } else if let transaction = interactor?.transactionHistory,
           let id = transaction.platform_id,
           let explorer = explorerCore.first(where: { $0.platformId?.uppercased() == id.uppercased() }),
           let urlString = explorer.address?.split(separator: "$").first,
           let txId = transaction.hash,
           let url = URL(string: String(urlString + txId)){
            UIApplication.shared.open(url)
        } else { return }
    }
    
    func openWebBrowser() {
        guard let urlString = interactor?.transactionDetailUrl, let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    func shouldOpenWebBrowser() -> Bool {
        return interactor?.shouldOpenWebBroswer() ?? false
    }
    
    func loadDataCompleted() {
        guard let transaction = self.interactor?.transactionHistory else { return }
        self.view?.setupTransaction(transaction: transaction)
        if let tranStatus = transaction.status, tranStatus == .canceled, tranStatus == .done {
            self.destroyTimer()
        }
    }
}

extension DepositDetailPresenter: InteractorToPresenterDepositDetailProtocol {
    
}
