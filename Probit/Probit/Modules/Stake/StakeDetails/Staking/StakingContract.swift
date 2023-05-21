//
//  StakingContract.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 23/09/2565 BE.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewStakingProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterStakingProtocol {
    var view: PresenterToViewStakingProtocol? { get set }
    var interactor: PresenterToInteractorStakingProtocol? { get set }
    var router: PresenterToRouterStakingProtocol? { get set }
    func navigateToStakeAmount()
    func navigateToUnStake()
    func navigateToStakeHistory()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorStakingProtocol {
    var presenter: InteractorToPresenterStakingProtocol? { get set }
    var displayName: String? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterStakingProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterStakingProtocol {
    func navigateToStakeAmount()
    func navigateToUnStake()
    func navigateToStakeHistory()
}
