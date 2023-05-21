//
//  MorePresenter.swift
//  Probit
//
//  Created by Nguyen Quang on 21/09/2022.
//  
//

import Foundation

class MorePresenter: ViewToPresenterMoreProtocol {
    // MARK: Properties
    var view: PresenterToViewMoreProtocol?
    var interactor: PresenterToInteractorMoreProtocol?
    var router: PresenterToRouterMoreProtocol?
    var mores: [MoreItem] { interactor?.mores ?? [] }
    
    func navigateNextScreen(type: MoreItem, viewController: BaseViewController) {
        router?.navigateNextScreen(type: type, viewController: viewController)
    }
}

extension MorePresenter: InteractorToPresenterMoreProtocol {
    
}
