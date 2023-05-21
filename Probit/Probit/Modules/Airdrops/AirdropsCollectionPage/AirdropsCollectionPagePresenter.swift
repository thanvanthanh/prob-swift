//
//  AirdropsCollectionPagePresenter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 26/12/2565 BE.
//  
//

import Foundation

class AirdropsCollectionPagePresenter: ViewToPresenterAirdropsCollectionPageProtocol {

    func viewDidLoad() {
        view?.showLoading()
        interactor?.getData()
    }
    
    // MARK: Properties
    var view: PresenterToViewAirdropsCollectionPageProtocol?
    var interactor: PresenterToInteractorAirdropsCollectionPageProtocol?
    var router: PresenterToRouterAirdropsCollectionPageProtocol?
    func loadMore() {
        view?.showLoading()
        interactor?.nextPage()
    }
    
}

extension AirdropsCollectionPagePresenter: InteractorToPresenterAirdropsCollectionPageProtocol {
    func pageNotEmpty() {
        view?.showFooterLoadMore()
    }
    
    func handerApiError(error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
    
    func getListAirdropSucces() {
        view?.hideLoading()
        view?.reloadData()
    }
}
