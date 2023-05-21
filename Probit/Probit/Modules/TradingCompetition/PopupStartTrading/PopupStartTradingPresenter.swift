//
//  PopupStartTradingPresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 26/09/2022.
//  
//

import Foundation

class PopupStartTradingPresenter: ViewToPresenterPopupStartTradingProtocol {
    
    // MARK: Properties
    var view: PresenterToViewPopupStartTradingProtocol?
    var interactor: PresenterToInteractorPopupStartTradingProtocol?
    var router: PresenterToRouterPopupStartTradingProtocol?
    var marketIds: [String] = []
    
    func gotoExchangeDetail(marketId: String) {
        router?.gotoExchangeDetail(marketId: marketId)
    }
}

extension PopupStartTradingPresenter: InteractorToPresenterPopupStartTradingProtocol {
    
}
