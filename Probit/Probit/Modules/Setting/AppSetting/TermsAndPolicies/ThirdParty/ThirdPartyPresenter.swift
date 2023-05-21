//
//  ThirdPartyPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/12/2022.
//  
//

import Foundation

class ThirdPartyPresenter: ViewToPresenterThirdPartyProtocol {
    // MARK: Properties
    var view: PresenterToViewThirdPartyProtocol?
    var interactor: PresenterToInteractorThirdPartyProtocol?
    var router: PresenterToRouterThirdPartyProtocol?
    
    func navigateToWeb(url: URL) {
        router?.navigateToWeb(url: url)
    }
    
    func navigateToList() {
        router?.navigateToList()
    }
}

extension ThirdPartyPresenter: InteractorToPresenterThirdPartyProtocol {
    
}
