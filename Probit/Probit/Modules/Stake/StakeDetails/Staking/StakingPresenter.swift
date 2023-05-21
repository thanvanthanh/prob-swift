//
//  StakingPresenter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 23/09/2565 BE.
//  
//

import Foundation

class StakingPresenter: ViewToPresenterStakingProtocol {
    // MARK: Properties
    var view: PresenterToViewStakingProtocol?
    var interactor: PresenterToInteractorStakingProtocol?
    var router: PresenterToRouterStakingProtocol?
    
    func navigateToUnStake() {
        router?.navigateToUnStake()
    }
    
    func navigateToStakeAmount() {
        router?.navigateToStakeAmount()
    }
    
    func navigateToStakeHistory() {
        router?.navigateToStakeHistory()
    }
    
}

extension StakingPresenter: InteractorToPresenterStakingProtocol {
    
}
