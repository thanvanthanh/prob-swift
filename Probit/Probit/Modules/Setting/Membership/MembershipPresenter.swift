//
//  MembershipPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 30/08/2022.
//  
//

import Foundation

class MembershipPresenter: ViewToPresenterMembershipProtocol {
    var stakeInteracter: StakeDetailsInteractorProtocol?

    // MARK: Properties
    var view: PresenterToViewMembershipProtocol?
    var interactor: PresenterToInteractorMembershipProtocol?
    var router: PresenterToRouterMembershipProtocol?
    var membershipData: MembershipModel? { interactor?.membershipData }
    var userBalanceData: String? { interactor?.userBalanceData }
    var feesDiscount: String? { interactor?.feesDiscount }
    var progressBarRate: Float? { interactor?.progressBarRate }
    var myStakeAmount: String? { interactor?.myStakeAmount }
    var countProbToLevel: String? { interactor?.countProbToLevel }
    
    func getData() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func navigateToTradingFeeWebsite(viewcontroller: BaseViewController) {
        router?.navigateToTradingFeeWebsite(viewcontroller: viewcontroller)
    }
    
    func navigateToStake() {
        //router?.navigateToStake()
    }
}

extension MembershipPresenter: InteractorToPresenterMembershipProtocol {
    func callingApiComplete() {
        view?.callingApiComplete()
    }
    
    func loadApiError() {
        view?.loadApiError()
    }
}
