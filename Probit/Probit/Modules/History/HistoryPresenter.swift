//
//  HistoryPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 29/08/2022.
//  
//

import Foundation

class HistoryPresenter: ViewToPresenterHistoryProtocol {
    var currentPage: Int {
        interactor?.currentPage ?? 0
    }
    
    // MARK: Properties
    var view: PresenterToViewHistoryProtocol?
    var interactor: PresenterToInteractorHistoryProtocol?
    var router: PresenterToRouterHistoryProtocol?
    
    var menus: [MenuBar] { interactor?.menus ?? [] }
    
    func viewDidLoad() {
        interactor?.getData()
    }
    
    func didSelectMenuItem(index: IndexPath) {
        view?.loadDataPageView(page: index.row)
        interactor?.didSelectMenuItem(index: index)
    }
}

extension HistoryPresenter: InteractorToPresenterHistoryProtocol {
    func dataListDidFetch() {
        view?.getDataSuccess()
    }
    
    func changeStateMenuSuccess() {
        view?.reloadData()
    }
}
