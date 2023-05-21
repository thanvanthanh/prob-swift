//
//  StakingAmountContract.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 30/09/2565 BE.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewStakingAmountProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterStakingAmountProtocol {
    var view: PresenterToViewStakingAmountProtocol? { get set }
    var interactor: PresenterToInteractorStakingAmountProtocol? { get set }
    var router: PresenterToRouterStakingAmountProtocol? { get set }
    func goToTerm(currencyId: String, period: Int, amount: String)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorStakingAmountProtocol {
    var presenter: InteractorToPresenterStakingAmountProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterStakingAmountProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterStakingAmountProtocol {
    var stakingType: StakingType { get }
    func goToTerm(currencyId: String, period: Int, amount: String)
}
