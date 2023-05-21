//
//  StakeSearchContract.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 23/09/2565 BE.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewStakeSearchProtocol {
    func reloadTableSearch()
    func hideLoading()
    func showLoading()
    func showError(error: ServiceError)
    func showSuccess(message: String)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterStakeSearchProtocol {
    var view: PresenterToViewStakeSearchProtocol? { get set }
    var interactor: PresenterToInteractorStakeSearchProtocol? { get set }
    var router: PresenterToRouterStakeSearchProtocol? { get set }
    func doSearch(_ text: String)
    func viewWillAppear()
    var stakeListSearch: [StakeEventModel] { get }
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorStakeSearchProtocol {
    var presenter: InteractorToPresenterStakeSearchProtocol? { get set }
    var stakeList: [StakeEventModel] { get set }
    var stakeListSearch: [StakeEventModel] { get set }
    func getData()
    var stakeCurrencies: [StakeCurrency] { get set }
    var walletCurrencies: [WalletCurrency] { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterStakeSearchProtocol {
    func doSearchSucces()
    func changeStateResponseSucces()
    func handerApiError(error: ServiceError)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterStakeSearchProtocol {
}
