//
//  StakeSearchPresenter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 23/09/2565 BE.
//  
//

import Foundation

class StakeSearchPresenter: ViewToPresenterStakeSearchProtocol {
    func doSearch(_ text: String) {
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else { return }
            let stakeList = self.interactor?.stakeList ?? []
            self.interactor?.stakeListSearch = stakeList.filter({ stake  in
                let name = stake.uiDescription?.locales?.enUs?.eventName ?? ""
                if name == "" { return true }
                return name.asTrimmed.lowercased().contains(text.lowercased().asTrimmed)
            })
            DispatchQueue.main.async {
                self.doSearchSucces()
            }
        }
    }
    
    func viewWillAppear() {
        view?.showLoading()
        self.interactor?.getData()
    }
    
    var stakeListSearch: [StakeEventModel] {
        get {
            interactor?.stakeListSearch ?? []
        }
    }
    
    // MARK: Properties
    var view: PresenterToViewStakeSearchProtocol?
    var interactor: PresenterToInteractorStakeSearchProtocol?
    var router: PresenterToRouterStakeSearchProtocol?
}

extension StakeSearchPresenter: InteractorToPresenterStakeSearchProtocol {
    
    func handerApiError(error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
    
    func doSearchSucces() {
        view?.reloadTableSearch()
    }
    
    
    func changeStateResponseSucces() {
        view?.hideLoading()
    }
    
}
