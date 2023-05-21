//
//  TradingCompetitionPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 22/09/2022.
//  
//

import Foundation

class TradingCompetitionPresenter: ViewToPresenterTradingCompetitionProtocol {
    // MARK: Properties
    var view: PresenterToViewTradingCompetitionProtocol?
    var interactor: PresenterToInteractorTradingCompetitionProtocol?
    var router: PresenterToRouterTradingCompetitionProtocol?
    
    var menus: [MenuBar] { interactor?.menus ?? [] }
    var tradings: [Trading] { interactor?.tradings ?? [] }
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func didSelectMenuItem(index: IndexPath) {
        interactor?.didSelectMenuItem(index: index)
    }
    
    func navigateToTradingSearch() {
        router?.navigateToTradingSearch(data: tradings)
    }
}

extension TradingCompetitionPresenter: InteractorToPresenterTradingCompetitionProtocol {
    func getListTradingSuccess() {
        view?.hideLoading()
        view?.getDataSuccess()
    }
    
    func changeStateMenuSuccess() {
        view?.reloadData()
    }
    
    func handerApiError(error: ServiceError) {
        view?.hideLoading()
    }
}
