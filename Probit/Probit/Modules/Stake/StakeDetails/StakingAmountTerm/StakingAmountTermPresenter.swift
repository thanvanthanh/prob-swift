//
//  StakingAmountTermPresenter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 03/10/2565 BE.
//  
//

import Foundation

class StakingAmountTermPresenter: ViewToPresenterStakingAmountTermProtocol {
    func doUnStake() {
        view?.showLoading()
        interactor?.doUnStake()
    }
    
    var interactorDetail: StakeDetailsInteractorProtocol
    
    init(interactorDetail: StakeDetailsInteractorProtocol) {
        self.interactorDetail = interactorDetail
    }
    
    func doStake() {
        view?.showLoading()
        interactor?.doStake()
    }
    
    // MARK: Properties
    var view: PresenterToViewStakingAmountTermProtocol?
    var interactor: PresenterToInteractorStakingAmountTermProtocol?
    var router: PresenterToRouterStakingAmountTermProtocol?
}

extension StakingAmountTermPresenter: InteractorToPresenterStakingAmountTermProtocol {
    // TODO: Implement View Output Methods
    func handleSuccess() {
        view?.showPopupSuccess()
        view?.hideLoading()
        interactorDetail.reloadData {}
    }
    
    func handleError(_ error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
    
}
