//
//  FillterHistoryPresenter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 12/10/2565 BE.
//  
//

import Foundation

class FillterHistoryPresenter: ViewToPresenterFillterHistoryProtocol {
    var isHideCurrencyView: Bool?
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.getData()
    }
    
    // MARK: Properties
    var view: PresenterToViewFillterHistoryProtocol?
    var interactor: PresenterToInteractorFillterHistoryProtocol?
    var router: PresenterToRouterFillterHistoryProtocol?
}

extension FillterHistoryPresenter: InteractorToPresenterFillterHistoryProtocol {
    func handerApiError(error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
    
    func changeStateResponseSucces() {
        view?.bindDataView()
        view?.hideLoading()
    }
}
