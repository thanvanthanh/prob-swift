//
//  StakeHistoryPagePresenter.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 06/10/2565 BE.
//  
//

import Foundation

class StakeHistoryPagePresenter: ViewToPresenterStakeHistoryPageProtocol {
    // MARK: Properties
    var view: PresenterToViewStakeHistoryPageProtocol?
    var interactor: PresenterToInteractorStakeHistoryPageProtocol?
    var router: PresenterToRouterStakeHistoryPageProtocol?
}

extension StakeHistoryPagePresenter: InteractorToPresenterStakeHistoryPageProtocol {
    
}
