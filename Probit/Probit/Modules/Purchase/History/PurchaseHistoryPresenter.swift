//
//  PurchaseHistoryPresenter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 19/10/2565 BE.
//  
//

import Foundation

class PurchaseHistoryPresenter: ViewToPresenterPurchaseHistoryProtocol {
    func viewDidLoad() {
        view?.showLoading()
        interactor?.getData()
    }
    
    // MARK: Properties
    var view: PresenterToViewPurchaseHistoryProtocol?
    var interactor: PresenterToInteractorPurchaseHistoryProtocol?
    var router: PresenterToRouterPurchaseHistoryProtocol?
}

extension PurchaseHistoryPresenter: InteractorToPresenterPurchaseHistoryProtocol {
    func getDataSuccess() {
        view?.hideLoading()
        view?.updateUI()
    }
    
    func getDataFailed(_ error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
}
