//
//  StakingAmountTermContract.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 03/10/2565 BE.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewStakingAmountTermProtocol {
    func hideLoading()
    func showLoading()
    func showPopupSuccess()
    func showError(error: ServiceError)
    func showSuccess(message: String)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterStakingAmountTermProtocol {
    var view: PresenterToViewStakingAmountTermProtocol? { get set }
    var interactor: PresenterToInteractorStakingAmountTermProtocol? { get set }
    var router: PresenterToRouterStakingAmountTermProtocol? { get set }
    var interactorDetail: StakeDetailsInteractorProtocol { get }
    func doStake()
    func doUnStake()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorStakingAmountTermProtocol {
    var presenter: InteractorToPresenterStakingAmountTermProtocol? { get set }
    func doStake()
    func doUnStake()
    var currencyId: String { get }
    var period: Int { get }
    var amount: String { get }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterStakingAmountTermProtocol {
    func handleSuccess()
    func handleError(_ error: ServiceError)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterStakingAmountTermProtocol {
    var stakeTermType: StakingType { get set }
}
