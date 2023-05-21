//
//  OrderHistoryPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 29/08/2022.
//  
//

import Foundation

class OrderHistoryPresenter: ViewToPresenterOrderHistoryProtocol {
    // MARK: Properties
    var view: PresenterToViewOrderHistoryProtocol?
    var interactor: PresenterToInteractorOrderHistoryProtocol?
    var router: PresenterToRouterOrderHistoryProtocol?
    
    func viewWillAppear() {
        view?.showLoading()
        interactor?.getData()
    }
}

extension OrderHistoryPresenter: InteractorToPresenterOrderHistoryProtocol {
    
    func handerApiError(error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
    
    func changeStateResponseSucces() {
        view?.hideLoading()
        view?.reloadData()
    }
}
