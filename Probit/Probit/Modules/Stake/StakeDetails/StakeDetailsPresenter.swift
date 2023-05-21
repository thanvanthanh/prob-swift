//
//  StakeDetailsPresenter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 23/09/2565 BE.
//  
//

import Foundation

class StakeDetailsPresenter: ViewToPresenterStakeDetailsProtocol {
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
    
    // MARK: Properties
    var view: PresenterToViewStakeDetailsProtocol?
    var interactor: PresenterToInteractorStakeDetailsProtocol?
    var router: PresenterToRouterStakeDetailsProtocol?
    func cryptoTransfersUpdateViewExchageRate() {
        interactor?.updateCryptoTransfersRouterVC()
    }
}

extension StakeDetailsPresenter: InteractorToPresenterStakeDetailsProtocol {
    func handerApiError(error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
    
    func changeStateMenuSuccess() {
        view?.reloadDataTopMenu()
    }
    
    func changeStateResponseSucces() {
        view?.hideLoading()
        view?.reloadDataTopMenu()
    }
    
}
