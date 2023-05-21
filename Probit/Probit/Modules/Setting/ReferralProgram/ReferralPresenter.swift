//
//  ReferralPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 29/08/2022.
//  
//

import Foundation

class ReferralPresenter: ViewToPresenterReferralProtocol {

    // MARK: Properties
    var view: PresenterToViewReferralProtocol?
    var interactor: PresenterToInteractorReferralProtocol?
    var router: PresenterToRouterReferralProtocol?
    var referrerCount: String? { interactor?.referrerCount }
    var referrerCode: String? { interactor?.referrerCode }
    var commissionFee: String? { interactor?.commissionFee }
    var referrerEarned: [ReferrerEarnedModel]? { interactor?.referrerEarned }
    
    func getData() {
        view?.showLoading()
        interactor?.getData()
    }
}

extension ReferralPresenter: InteractorToPresenterReferralProtocol {
    func callingApiComplete() {
        view?.callingApiComplete()
    }
    
    func loadApiError() {
        view?.loadApiError()
    }
}
