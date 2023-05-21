//
//  TradeHistoryPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 29/08/2022.
//  
//

import Foundation

class TradeHistoryPresenter: ViewToPresenterTradeHistoryProtocol {
    // MARK: Properties
    var view: PresenterToViewTradeHistoryProtocol?
    var interactor: PresenterToInteractorTradeHistoryProtocol?
    var router: PresenterToRouterTradeHistoryProtocol?
    
    func viewWillAppear() {
        view?.showLoading()
        interactor?.getData()
    }
}

extension TradeHistoryPresenter: InteractorToPresenterTradeHistoryProtocol {
    func handerApiError(error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
    
    func changeStateResponseSucces() {
        view?.hideLoading()
        view?.reloadView()
    }
}
