//
//  TradingCompetitionDetailInteractor.swift
//  Probit
//
//  Created by Nguyen Quang on 22/09/2022.
//  
//

import Foundation

class TradingCompetitionDetailInteractor: PresenterToInteractorTradingCompetitionDetailProtocol {
    // MARK: Properties
    var presenter: InteractorToPresenterTradingCompetitionDetailProtocol?
    var entity: InteractorToEntityTradingCompetitionDetailProtocol?
    var tradingDetail: TradingDetail?
    var myStatusKyc: Int?
    var myStatusStake: String?
    var tradingLeaderboard: TradingLeaderboard?
    
    var membershipData: MembershipModel?
    var stakeList: [StakeEventModel] = []
    var stakeCurrencies: [StakeCurrency] = []
    var walletCurrencies: [WalletCurrency] = []
    var markets: [Market] = []
    var userBalancies: [UserBalance] = []

    var stakeAmount: StakeAmountModel?
    
    var productService = GatewayApiProductService()
    var getMarket: GetMarketAction
    var getCurrencyWithPlatform: GetCurrencyWithPlatformAction
    var isIneligible: Bool = false
    
    init() {
        self.getCurrencyWithPlatform = GetCurrencyWithPlatformAction(dataSource: productService )
        self.getMarket = GetMarketAction(serviceType: "", dataSource: productService)
    }

    func getData(id: String) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        entity?.getListTradecompetitionDetail(id: id, completionHandler: { [weak self] result in
            dispatchGroup.leave()
            guard let `self` = self else { return }
            switch result {
            case let .success(response):
                self.tradingDetail = response.data
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
        })
        dispatchGroup.enter()
        entity?.getLeaderboardTrading(id: id,
                                      completionHandler: { [weak self] result in
            dispatchGroup.leave()
            guard let `self` = self else { return }
            switch result {
            case let .success(response):
                self.tradingLeaderboard = response
                self.isIneligible = response.isIneligible ?? false
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
        })
        dispatchGroup.enter()
        entity?.checkStep(completionHandler: { [weak self] result in
            dispatchGroup.leave()
            guard let `self` = self else { return }
            switch result {
            case let .success(response):
                self.myStatusKyc = response.data
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
        })
        dispatchGroup.enter()
        entity?.getStakeUser(completionHandler: { [weak self] result in
            dispatchGroup.leave()
            guard let `self` = self else { return }
            switch result {
            case let .success(response):
                self.myStatusStake = response.data?.prob
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
        })
        
        dispatchGroup.enter()
        entity?.membership(completionHandler: { [weak self] result in
            dispatchGroup.leave()
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                self.membershipData = data
            case .failure(let error):
                self.presenter?.handerApiError(error: error)
            }
        })
        dispatchGroup.enter()
        getWalletCurrencies {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getStakeAmount {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getMarkets {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getStakeEvent {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getStakeCurrency {
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
            self.presenter?.getDataSuccess()
        })
    }

    func getKycStatusModel() {
        SettingAPI.shared.userKycStatus { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                self.presenter?.getKycStatusModelSuccesed(kycStatusModel: data.data)
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
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
    
    private func getStakeAmount(completed: @escaping() -> Void) {
        StakeAPI.shared.getStakeAmount("PROB") { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let stakeAmountData):
                self.stakeAmount = stakeAmountData.data
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
            completed()
        }
    }
    
    func getBalance(completed: @escaping() -> Void) {
        StakeAPI.shared.getBalance{ [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let balancyData):
                self.userBalancies = balancyData.data
            case .failure(let error):
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
            case .failure(let error):
                self.presenter?.handerApiError(error: error)
            }
            completed()
        }
    }
    
    func getStakeEvent(completed: @escaping() -> Void) {
        StakeAPI.shared.getStakeEvent { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let listStake):
                let stakeList = listStake.data.map({ entity in
                    return StakeEventModel.init(entity: entity)
                })
                self.stakeList = stakeList.sorted(by: { a, b in
                    if a.stakeEventType.rawValue != b.stakeEventType.rawValue {
                        return a.stakeEventType.rawValue < b.stakeEventType.rawValue
                    } else {
                        switch a.stakeEventType {
                        case .RUNNING:
                            if let aEnd = a.endTime?.timeIntervalSince1970,let bEnd = b.endTime?.timeIntervalSince1970 {
                                return aEnd < bEnd
                            } else {
                                return false
                            }
                        case .UP_COMING:
                            if let aStart = a.startTime?.timeIntervalSince1970, let bStart = b.startTime?.timeIntervalSince1970 {
                                return aStart < bStart
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
            case .failure(let error):
                self.presenter?.handerApiError(error: error)
            }
            completed()
        }
    }
}

extension TradingCompetitionDetailInteractor: StakeDetailsInteractorProtocol {
    var currencies: [WalletCurrency]? {
        walletCurrencies
    }
    
    var stakeEvent: StakeEventModel? {
        return stakeList.first(where: { $0.currencyId == "PROB"})
    }
    
    var stakeCurrency: StakeCurrency? {
        stakeCurrencies.first(where: { $0.currencyId == "PROB"})
    }
    
    var walletCurrency: WalletCurrency? {
        walletCurrencies.first(where: { $0.id == "PROB"})
    }
    
    var membership: MembershipDetailModel? {
        return membershipData?.data
    }
    
    func reloadData(_ completion: @escaping () -> Void) {
    }
}
