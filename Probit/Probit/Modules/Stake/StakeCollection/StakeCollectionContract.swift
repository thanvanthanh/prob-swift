//
//  StakeCollectionContract.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 22/09/2565 BE.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewStakeCollectionProtocol {
    func reloadData()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterStakeCollectionProtocol {
    var view: PresenterToViewStakeCollectionProtocol? { get set }
    var interactor: PresenterToInteractorStakeCollectionProtocol? { get set }
    var router: PresenterToRouterStakeCollectionProtocol? { get set }
    var stakeFilted: [StakeEventModel] { get }
    var type: StakeCollectionType { get }
    func filterByTypeStakeList()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorStakeCollectionProtocol {
    var presenter: InteractorToPresenterStakeCollectionProtocol? { get set }
    var stakeList: [StakeEventModel] { get set }
    var stakeCurrencies: [StakeCurrency] { get set }
    var stakeFilted: [StakeEventModel] { get set }
    var walletCurrencies: [WalletCurrency] { get set }
    var type: StakeCollectionType { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterStakeCollectionProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterStakeCollectionProtocol {
    func navigateToStakeDetails(stakeEvent: StakeEventModel,
                                stakeCurrency: StakeCurrency?,
                                walletCurrency: WalletCurrency)
}
