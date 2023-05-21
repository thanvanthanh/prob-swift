//
//  StakeInteractor.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 22/09/2565 BE.
//  
//

import Foundation

class StakeInteractor: PresenterToInteractorStakeProtocol {
    
    var menus: [MenuBar]
    let tabAll = StakeCollectionRouter().createModule(type: .ALL)
    let tabUpComing = StakeCollectionRouter().createModule(type: .UP_COMING)
    let tabRunning = StakeCollectionRouter().createModule(type: .RUNNING)
    var stakeList: [StakeEventModel] = []
    var stakeCurrencies: [StakeCurrency] = []
    var walletCurrencies: [WalletCurrency] = []
    var userBalancies: [UserBalance] = []
    var markets: [Market] = []

    var productService = GatewayApiProductService()
    var getCurrencyWithPlatform: GetCurrencyWithPlatformAction
    var getMarket: GetMarketAction

    init() {
        menus = [MenuBar(name: "stakeevent_tab_upcoming".Localizable(),
                          icon: nil,
                          controller: tabUpComing),
                  MenuBar(name: "stakeevent_tab_running".Localizable(),
                          icon: nil,
                          controller: tabRunning),
                  MenuBar(name: "stakeevent_tab_all".Localizable(),
                          icon: nil,
                          controller: tabAll, isSelected: true)]
        self.getCurrencyWithPlatform = GetCurrencyWithPlatformAction(dataSource: productService )
        self.getMarket = GetMarketAction(serviceType: "", dataSource: productService)
    }
    
    // MARK: Properties
    var presenter: InteractorToPresenterStakeProtocol?
    
    func didSelectMenuItem(index: IndexPath) {
        menus.enumerated().forEach { (i, _) in
            menus[i].isSelected = false
        }
        menus[index.row].isSelected = true
        presenter?.changeStateMenuSuccess()
    }
    
    func getData() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        getStakeEvent {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getStakeCurrency {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getWalletCurrencies {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getMarkets {
            dispatchGroup.leave()
        }
        if AppConstant.isLogin {
            dispatchGroup.enter()
            getBalance {
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            guard let `self` = self else { return }
            self.walletCurrencies.forEach { currency in
                guard let id = currency.id else { return }
                currency.mapping(self.markets)
                if let stakeEvent = self.stakeList.first(where: { $0.currencyId == id }) {
                    currency.mapping(stakeEvent)
                }
                if let userBalancy = self.userBalancies.first(where: {$0.currencyID == id}) {
                    currency.mapping(userBalancy)
                }
            }
            (self.tabAll as? StakeCollectionViewController)?.setData(self.stakeList,
                                                                     self.stakeCurrencies,
                                                                     self.walletCurrencies)
            (self.tabUpComing as? StakeCollectionViewController)?.setData(self.stakeList,
                                                                          self.stakeCurrencies,
                                                                          self.walletCurrencies)
            (self.tabRunning as? StakeCollectionViewController)?.setData(self.stakeList,
                                                                         self.stakeCurrencies,
                                                                         self.walletCurrencies)
            self.presenter?.changeStateResponseSucces()
        })
    }
        
    func getStakeEvent(completed: @escaping() -> Void) {
        StakeAPI.shared.getStakeEvent { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let listStake):
                let stakeList = listStake.data.filter { $0.active ?? false }.map({ entity in
                    return StakeEventModel.init(entity: entity)
                })
                self.stakeList = stakeList.sorted(by: { a, b in
                    if a.stakeEventType.rawValue != b.stakeEventType.rawValue {
                        return a.stakeEventType.rawValue < b.stakeEventType.rawValue
                    } else {
                        switch a.stakeEventType {
                        case .RUNNING:
                            if let aStart = a.startTime?.timeIntervalSince1970,let bStart = b.startTime?.timeIntervalSince1970 {
                                return aStart > bStart
                            } else {
                                return false
                            }
                        case .UP_COMING:
                            if let aStart = a.startTime?.timeIntervalSince1970, let bStart = b.startTime?.timeIntervalSince1970 {
                                return aStart > bStart
                            } else {
                                return false
                            }
                        case .END:
                            if let aEnd = a.endTime?.timeIntervalSince1970,let bEnd = b.endTime?.timeIntervalSince1970 {
                                return aEnd > bEnd
                            } else {
                                return false
                            }
                        }
                    }
                })
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
            completed()
        }
    }
    
    func getStakeCurrency(completed: @escaping() -> Void) {
        StakeAPI.shared.getStakeCurrency() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let currencyData):
                self.stakeCurrencies = currencyData.data
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
            completed()
        }
    }
    
    func getWalletCurrencies(completed: @escaping() -> Void) {
        getCurrencyWithPlatform.apiCall { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let res):
                var currencies: [WalletCurrency] = []
                res.data.forEach {
                    let currency = WalletCurrency()
                    currency.mapping($0)
                    currencies.append(currency)
                }
                self.walletCurrencies = currencies
            case .failure(let error):
                self.presenter?.handerApiError(error: error)
            }
            completed()
        }
    }
    
    func getMarkets(completed: @escaping() -> Void) {
        getMarket.apiCall { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let res):
                let markets = res.data
                self.markets = markets
            case .failure(let error):
                self.presenter?.handerApiError(error: error)
            }
        }
        completed()
    }
    
    func getBalance(completed: @escaping() -> Void) {
        StakeAPI.shared.getBalance{ [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let balancyData):
                self.userBalancies = balancyData.data
                completed()
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
        }
    }
    
}
