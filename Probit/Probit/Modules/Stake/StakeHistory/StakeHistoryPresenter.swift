//
//  StakeHistoryPresenter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 06/10/2565 BE.
//  
//

import Foundation

class StakeHistoryPresenter: ViewToPresenterStakeHistoryProtocol {
    // MARK: Properties
    var view: PresenterToViewStakeHistoryProtocol?
    var interactor: PresenterToInteractorStakeHistoryProtocol?
    var router: PresenterToRouterStakeHistoryProtocol?
    
    var menus: [MenuBar] {
        interactor?.menus ?? []
    }
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func didSelectMenuItem(index: IndexPath) {
        interactor?.didSelectMenuItem(index: index)
    }
}

extension StakeHistoryPresenter: InteractorToPresenterStakeHistoryProtocol {
    func handerApiError(error: ServiceError) {
        view?.hideLoading()

    }
    
    func changeStateMenuSuccess() {
        view?.reloadDataTopMenu()
    }
    
    func changeStateResponseSucces() {
        view?.hideLoading()
        view?.reloadDataTopMenu()
    }
    
    
}
