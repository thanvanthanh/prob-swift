//
//  ThirdPartyListPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/12/2022.
//  
//

import Foundation

class ThirdPartyListPresenter: ViewToPresenterThirdPartyListProtocol {
    // MARK: Properties
    var view: PresenterToViewThirdPartyListProtocol?
    var interactor: PresenterToInteractorThirdPartyListProtocol?
    var router: PresenterToRouterThirdPartyListProtocol?
    var listThirdParty: [ThirdParty] { interactor?.listThirdParty ?? [] }
    
    func navigateToDetail(html: String) {
        router?.navigateToDetail(html: html)
    }
}

extension ThirdPartyListPresenter: InteractorToPresenterThirdPartyListProtocol {
    
}
