//
//  StakePresenter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 22/09/2565 BE.
//  
//

import Foundation

class StakePresenter: ViewToPresenterStakeProtocol {
    
    // MARK: Properties
    var view: PresenterToViewStakeProtocol?
    var interactor: PresenterToInteractorStakeProtocol?
    var router: PresenterToRouterStakeProtocol?
    var menus: [MenuBar] { interactor?.menus ?? [] }
    
    func navigateToSearch() {
        router?.navigateToSearch(stakeList: interactor?.stakeList ?? [])
    }
}

extension StakePresenter: InteractorToPresenterStakeProtocol {
    func changeStateResponseSucces() {
        view?.hideLoading()
    }
    
    func getData() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func handerApiError(error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
    
    func viewWillAppear() {
        getData()
    }
    
    func didSelectMenuItem(index: IndexPath) {
        interactor?.didSelectMenuItem(index: index)
    }
    
    func changeStateMenuSuccess() {
        view?.reloadDataTopMenu()
    }
}
