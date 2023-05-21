//
//  ThirdPartyDetailPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/12/2022.
//  
//

import Foundation

class ThirdPartyDetailPresenter: ViewToPresenterThirdPartyDetailProtocol {
    
    // MARK: Properties
    var view: PresenterToViewThirdPartyDetailProtocol?
    var interactor: PresenterToInteractorThirdPartyDetailProtocol?
    var router: PresenterToRouterThirdPartyDetailProtocol?
    var html: String?
    
    func navigateToWeb(url: URL) {
        router?.navigateToWeb(url: url)
    }
}

extension ThirdPartyDetailPresenter: InteractorToPresenterThirdPartyDetailProtocol {
    
}
