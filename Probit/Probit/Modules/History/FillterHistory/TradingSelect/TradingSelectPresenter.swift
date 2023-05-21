//
//  TradingSelectPresenter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 14/10/2565 BE.
//  
//

import Foundation

class TradingSelectPresenter: ViewToPresenterTradingSelectProtocol {

    // MARK: Properties
    var view: PresenterToViewTradingSelectProtocol?
    var interactor: PresenterToInteractorTradingSelectProtocol?
    var router: PresenterToRouterTradingSelectProtocol?
    
    func filterData(searchText: String) {
        interactor?.filterData(searchText: searchText)
    }

    func viewDidLoad() {
        
    }
    
}

extension TradingSelectPresenter: InteractorToPresenterTradingSelectProtocol {
    func dataListDidFetch() {
        view?.reloadData()
    }
}
