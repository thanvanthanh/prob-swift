//
//  StakeDetailsInteractor.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 23/09/2565 BE.
//  
//

import Foundation
protocol StakeDetailsInteractorProtocol {
    var stakeEvent: StakeEventModel? { get }
    var stakeCurrency: StakeCurrency? { get }
    var stakeAmount: StakeAmountModel? { get }
    var walletCurrency: WalletCurrency? { get }
    var membership: MembershipDetailModel? { get }
    var currencies: [WalletCurrency]? { get }
    func reloadData(_ completion: @escaping () -> Void)
}

extension StakeDetailsInteractor: StakeDetailsInteractorProtocol {

    func reloadData(_ completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        getStakeAmount {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getMembership {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getBalance {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getCurrencyWithPlatform.apiCall { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let res):
                var currencies: [WalletCurrency] = []
                res.data.forEach { data in
                    let currency = WalletCurrency()
                    currency.mapping(data)
                    if let userBalancy = self.userBalancies.first(where: {$0.currencyID == data.id}) {
                        currency.mapping(userBalancy)
                    }
                    currencies.append(currency)
                }
                self.currencies = currencies
                
            case .failure(_):
                break
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main, execute: {
            self.stakingRouteVC.billDataChart()
            self.stakingRouteVC.setupReward()
            self.presenter?.changeStateResponseSucces()
            DispatchQueue.global().async {
                guard let walletCurrency = self.currencies?.first(where: {$0.id == self.walletCurrency?.id}) else { return }
                DispatchQueue.main.async {
                    self.cryptoTransfersRouterVC.bindData(walletCurrency)
                }
            }
            completion()
        })
    }
}

class StakeDetailsInteractor: PresenterToInteractorStakeDetailsProtocol {
    var getCurrencyWithPlatform: GetCurrencyWithPlatformAction = GetCurrencyWithPlatformAction(dataSource: GatewayApiProductService())
    
    var parentTypeVC: TypeViewController
    
    lazy var stakingRouteVC: StakingViewController = {
        let vc = StakingRouter(interactorDetail: self).createModule() as! StakingViewController
        vc.stakeDetailsInteractorDelegate = self
        return vc
    }()
    
    lazy var cryptoTransfersRouterVC: CryptoTransfersViewController = {
        let vc = CryptoTransfersRouter().createModule(data: self.walletCurrency) as! CryptoTransfersViewController
        vc.stakeDetailsInteractorDelegate = self
        return vc
    }()
    
    var presenter: InteractorToPresenterStakeDetailsProtocol?
    lazy var menus: [MenuBar] = {
        return [MenuBar(name: "fragment_wallet_tab_coin".Localizable(),
                        icon: nil,
                        controller: cryptoTransfersRouterVC,
                        isSelected: parentTypeVC == .WALLET),
                MenuBar(name: "fragment_wallet_tab_staking".Localizable(),
                        icon: nil,
                        controller: stakingRouteVC,
                        isSelected: parentTypeVC != .WALLET)]
    }()
    
    var stakeEvent: StakeEventModel?
    var userBalancies: [UserBalance] = []
    var stakeCurrency: StakeCurrency?
    var stakeAmount: StakeAmountModel?
    var walletCurrency: WalletCurrency?
    var membership: MembershipDetailModel?
    var currencies: [WalletCurrency]?
    init(stakeEvent: StakeEventModel,
         stakeCurrency: StakeCurrency?,
         walletCurrency: WalletCurrency,
         parentTypeVC: TypeViewController) {
        self.stakeEvent = stakeEvent
        self.walletCurrency = walletCurrency
        self.stakeCurrency = stakeCurrency
        self.parentTypeVC = parentTypeVC
    }
    
    func didSelectMenuItem(index: IndexPath) {
        menus.enumerated().forEach { (i, _) in
            menus[i].isSelected = false
        }
        menus[index.row].isSelected = true
        presenter?.changeStateMenuSuccess()
    }
    
    // MARK: Properties
    func getData() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        getStakeAmount {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getMembership {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
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
                self.currencies = currencies
                
            case .failure(_):
                break
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main, execute: {
            self.stakingRouteVC.setupGoTrade()
            self.stakingRouteVC.billDataChart()
            self.stakingRouteVC.setupReward()
            self.presenter?.changeStateResponseSucces()
        })
    }
    
    func updateCryptoTransfersRouterVC() {
        guard let walletCurrency = self.walletCurrency else { return }
        self.cryptoTransfersRouterVC.bindData(walletCurrency)
    }
        
    private func getStakeAmount(completed: @escaping() -> Void) {
        guard let currencyId = stakeEvent?.currencyId else { return }
        StakeAPI.shared.getStakeAmount(currencyId) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let stakeAmountData):
                self.stakeAmount = stakeAmountData.data
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
            completed()
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
                strongSelf.presenter?.handerApiError(error: error)
            }
        }
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

