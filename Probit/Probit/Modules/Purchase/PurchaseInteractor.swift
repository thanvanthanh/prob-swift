//
//  PurchaseInteractor.swift
//  Probit
//
//  Created by Bradley Hoang on 27/09/2022.
//  
//

import Foundation

class PurchaseInteractor: PresenterToInteractorPurchaseProtocol {
    var purchaseRequest: PurchaseRequest
    
    // MARK: Properties
    var presenter: InteractorToPresenterPurchaseProtocol?
    var membership: MembershipDetailModel?
    var coinConversionConfig: CoinConversionConfigModel?
    var purchaseConversionRate: PurchaseConversionRate?
    var userBalances: [UserBalance] = []
    var stakeCurrency: StakeCurrency?
    var timer: Timer?
    var count = PurchaseConstants.countdownTime
    var walletCurrency: WalletCurrency?

    init() {
        self.purchaseRequest = PurchaseRequest(fromCurrencyId: "USDT",
                                               toCurrencyId: "PROB",
                                               toQuantity: "0",
                                               price: "0",
                                               stake: false)
    }
    
    func reloadDataLoged(purchaseModel: PurchaseModel) {
        let oldMemberShip = self.membership
        let waitingToStartGroup = DispatchGroup()
        waitingToStartGroup.enter()
        getMembership {
            waitingToStartGroup.leave()
        }
        waitingToStartGroup.enter()
        getCoinConversionConfig{
            waitingToStartGroup.leave()
        }
        waitingToStartGroup.enter()
        getUserBalances{
            waitingToStartGroup.leave()
        }
        waitingToStartGroup.enter()
        getStakeCurrency{
            waitingToStartGroup.leave()
        }
        waitingToStartGroup.enter()
        getConversionRate {
            waitingToStartGroup.leave()
        }
        waitingToStartGroup.enter()
        getWalletCurrencies {
            waitingToStartGroup.leave()
        }
        waitingToStartGroup.notify(queue: .main) { [weak self] in
            self?.presenter?.reloadDataLogedSuccess(purchaseModel: purchaseModel, oldMemberShip: oldMemberShip)
        }
    }

    func getDataLoged() {
        let waitingToStartGroup = DispatchGroup()
        waitingToStartGroup.enter()
        getMembership {
            waitingToStartGroup.leave()
        }
        waitingToStartGroup.enter()
        getCoinConversionConfig{
            waitingToStartGroup.leave()
        }
        waitingToStartGroup.enter()
        getUserBalances{
            waitingToStartGroup.leave()
        }
        waitingToStartGroup.enter()
        getStakeCurrency{
            waitingToStartGroup.leave()
        }
        waitingToStartGroup.enter()
        getConversionRate {
            waitingToStartGroup.leave()
        }
        waitingToStartGroup.enter()
        getWalletCurrencies {
            waitingToStartGroup.leave()
        }
        waitingToStartGroup.notify(queue: .main) { [weak self] in
            self?.presenter?.getDataSuccess()
        }
    }
    
    func getDataWithoutLogin() {
        let waitingToStartGroup = DispatchGroup()
        waitingToStartGroup.enter()
        getCoinConversionConfig {
            waitingToStartGroup.leave()
        }
        waitingToStartGroup.enter()
        getConversionRate {
            waitingToStartGroup.leave()
        }
        waitingToStartGroup.notify(queue: .main) { [weak self] in
            self?.presenter?.getDataSuccess()
        }
    }
    
    func startTimer() {
        stopTimer()
        count = PurchaseConstants.countdownTime
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(updateCountDownTime),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func buyCurrency() {
        PurchaseAPI.shared.buyCoinConversion(purchaseRequest: purchaseRequest) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let res):
                strongSelf.presenter?.purchaseSucces(purchaseModel: res.data)
            case let .failure(error):
                strongSelf.presenter?.getDataFailed(error)
            }
        }
    }
    
    func getConversionRate(completed: @escaping() -> Void) {
        PurchaseAPI.shared.getConversionRate { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let purchaseRate):
                strongSelf.purchaseConversionRate = purchaseRate.data
            case let .failure(error):
                strongSelf.presenter?.getDataFailed(error)
            }
            completed()
        }
    }
    
}


// MARK: - Private
private extension PurchaseInteractor {
    @objc func updateCountDownTime() {
        if count > 0 {
            count -= 1
            let isBlink = count <= PurchaseConstants.blinkTime
            presenter?.updateCountdownTime(with: count,
                                           isBlink: isBlink)
        } else {
            timer?.invalidate()
            timer = nil
            presenter?.reloadConversionRate()
        }
    }
    
    func getMembership(completed: @escaping() -> Void) {
        SettingAPI.shared.membership { [weak self] result in
            defer { completed() }
            guard let strongSelf = self else { return }
            switch result {
            case .success(let membership):
                strongSelf.membership = membership.data
            case let .failure(error):
                strongSelf.presenter?.getDataFailed(error)
            }
        }
    }

    func getCoinConversionConfig(completed: @escaping() -> Void) {
        PurchaseAPI.shared.getCoinConversionConfig { [weak self] result in
            defer { completed() }
            guard let strongSelf = self else { return }
            switch result {
            case .success(let config):
                strongSelf.coinConversionConfig = config
            case let .failure(error):
                strongSelf.presenter?.getDataFailed(error)
            }
        }
    }
    
    func getUserBalances(completed: @escaping() -> Void) {
        GetUserBalanceAction().apiCall { [weak self] result in
            defer { completed() }
            guard let strongSelf = self else { return }
            switch result {
            case .success(let userBalances):
                strongSelf.userBalances = userBalances.data
            case let .failure(error):
                strongSelf.presenter?.getDataFailed(error)
            }
        }
    }
    
    func getStakeCurrency(completed: @escaping() -> Void) {
        StakeAPI.shared.getStakeCurrency { [weak self] result in
            defer { completed() }
            guard let strongSelf = self else { return }
            switch result {
            case .success(let currencies):
                strongSelf.stakeCurrency = currencies.data.first(where: { $0.currencyId == PurchaseConstants.currencyId })
            case let .failure(error):
                strongSelf.presenter?.getDataFailed(error)
            }
        }
    }
    
    
    func getWalletCurrencies(completed: @escaping() -> Void) {
        HistoryAPI().getCurrencyWithPlatform { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let res):
                if let usdtCurrency = res.data.first(where: {$0.id == "USDT"}) {
                    let currency = WalletCurrency()
                    currency.mapping(usdtCurrency)
                    self.walletCurrency = currency
                }
            case .failure(let error):
                self.presenter?.getDataFailed(error)
            }
            completed()
        }
    }
}
