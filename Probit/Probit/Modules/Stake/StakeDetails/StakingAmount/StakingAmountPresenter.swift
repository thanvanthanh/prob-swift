//
//  StakingAmountPresenter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 30/09/2565 BE.
//  
//

import Foundation

class StakingAmountPresenter: ViewToPresenterStakingAmountProtocol {
    // MARK: Properties
    var view: PresenterToViewStakingAmountProtocol?
    var interactor: PresenterToInteractorStakingAmountProtocol?
    var router: PresenterToRouterStakingAmountProtocol?
    
    func goToTerm(currencyId: String, period: Int, amount: String) {
        router?.goToTerm(currencyId: currencyId, period: period, amount: amount)

    }
}

extension StakingAmountPresenter: InteractorToPresenterStakingAmountProtocol {
    
}
