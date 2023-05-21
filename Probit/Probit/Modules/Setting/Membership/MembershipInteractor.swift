//
//  MembershipInteractor.swift
//  Probit
//
//  Created by Thân Văn Thanh on 30/08/2022.
//  
//

import Foundation

class MembershipInteractor: PresenterToInteractorMembershipProtocol {

    // MARK: Properties
    var presenter: InteractorToPresenterMembershipProtocol?
    var entity: InteractorToEntityMembershipProtocol?
    var membershipData: MembershipModel?
    var userBalanceData: String?
    var feesDiscount: String?
    var progressBarRate: Float?
    var myStakeAmount: String?
    var countProbToLevel: String?
    var stakeList: [StakeEventModel] = []
    var stakeCurrencies: [StakeCurrency] = []
    var walletCurrencies: [WalletCurrency] = []
    var markets: [Market] = []
    var userBalancies: [UserBalance] = []

    var stakeAmount: StakeAmountModel?
    
    var productService = GatewayApiProductService()
    var getMarket: GetMarketAction
    var getCurrencyWithPlatform: GetCurrencyWithPlatformAction
    
    init() {
        self.getCurrencyWithPlatform = GetCurrencyWithPlatformAction(dataSource: productService )
        self.getMarket = GetMarketAction(serviceType: "", dataSource: productService)
    }
    
    func getData() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        entity?.membership(completionHandler: { result in
            dispatchGroup.leave()
            switch result {
            case .success(let success):
                self.membershipData = success
                self.setupData(model: success.data)
            case .failure:
                self.presenter?.loadApiError()
            }
        })
        dispatchGroup.enter()
        entity?.getUserBalance(completionHandler: { result in
            dispatchGroup.leave()
            switch result {
            case .success(let success):
                self.userBalanceData = success.data.first(where: { $0.currencyID == "PROB" })?.available
            case .failure(let failure):
                print(failure)
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
            self.presenter?.callingApiComplete()
        })
    }
    
    func setupData(model: MembershipDetailModel) {
        let tradeFee = model.tradeFeeRateByProb.asDouble()
        let tradeFeeRate = model.tradeFeeRate.asDouble()
        let tradeFeeDiscount = 1 - (tradeFee / tradeFeeRate)
        self.feesDiscount = tradeFeeDiscount.string.toPercentage
        let nextLevel = (model.stakeAmount.asDouble() + model.nextLevel.asDouble())
        
        if model.membershipType == .vip11 {
            self.progressBarRate = 1
        } else {
            self.progressBarRate = (model.stakeAmount.floatValue / Float(nextLevel)).fractionDigits(min: 2, max: 2).floatValue
        }
        self.myStakeAmount =  AppConstant.isLanguageRightToLeft ?  "PROB \(model.stakeAmount.replaceCurrency())" : "\(model.stakeAmount.replaceCurrency()) PROB"
        let nextStr = nextLevel.fractionDigits(min: 0, max: 2)
        self.countProbToLevel =  AppConstant.isLanguageRightToLeft  ? "≥ PROB \(nextStr)" : "≥ \(nextStr) PROB"
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
            case .failure:
                self.presenter?.loadApiError()
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
            case .failure:
                self.presenter?.loadApiError()
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
            case .failure:
                self.presenter?.loadApiError()
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
            case .failure:
                self.presenter?.loadApiError()
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
            case .failure:
                self.presenter?.loadApiError()
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
            case .failure:
                self.presenter?.loadApiError()
            }
            completed()
        }
    }
}

extension MembershipInteractor: StakeDetailsInteractorProtocol {
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
