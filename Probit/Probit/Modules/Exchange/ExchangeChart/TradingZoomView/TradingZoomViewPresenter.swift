//
//  TradingZoomViewPresenter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 10/01/2566 BE.
//  
//

import Foundation

class TradingZoomViewPresenter: ViewToPresenterTradingZoomViewProtocol {
    // MARK: Properties
    var view: PresenterToViewTradingZoomViewProtocol?
    var interactor: PresenterToInteractorTradingZoomViewProtocol?
    var router: PresenterToRouterTradingZoomViewProtocol?
}

extension TradingZoomViewPresenter: InteractorToPresenterTradingZoomViewProtocol {
    
}
