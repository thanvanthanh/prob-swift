//
//  StakeDetailsContract.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 23/09/2565 BE.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewStakeDetailsProtocol {
    func reloadDataTopMenu()
    func hideLoading()
    func showLoading()
    func showError(error: ServiceError)
    func showSuccess(message: String)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterStakeDetailsProtocol {
    var view: PresenterToViewStakeDetailsProtocol? { get set }
    var interactor: PresenterToInteractorStakeDetailsProtocol? { get set }
    var router: PresenterToRouterStakeDetailsProtocol? { get set }
    var menus: [MenuBar] { get }
    func cryptoTransfersUpdateViewExchageRate()
    func viewDidLoad()
    func didSelectMenuItem(index: IndexPath)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorStakeDetailsProtocol {
    var presenter: InteractorToPresenterStakeDetailsProtocol? { get set }
    var stakeEvent: StakeEventModel? { get set }
    func getData()
    var menus: [MenuBar] { get set }
    func didSelectMenuItem(index: IndexPath)
    var stakingRouteVC: StakingViewController { get }
    var parentTypeVC: TypeViewController { get }
    var cryptoTransfersRouterVC: CryptoTransfersViewController { get }
    func updateCryptoTransfersRouterVC()
    var userBalancies: [UserBalance] { get set }
    var stakeCurrency: StakeCurrency? { get set }
    var stakeAmount: StakeAmountModel? { get set }
    var walletCurrency: WalletCurrency? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterStakeDetailsProtocol {
    func handerApiError(error: ServiceError)
    func changeStateMenuSuccess()
    func changeStateResponseSucces()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterStakeDetailsProtocol {
}

enum TypeViewController {
    case STAKE
    case STAKE_SEARCH
    case WALLET
}
