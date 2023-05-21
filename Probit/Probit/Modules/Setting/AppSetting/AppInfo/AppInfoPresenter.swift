//
//  AppInfoPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//  
//

import Foundation

class AppInfoPresenter: ViewToPresenterAppInfoProtocol {

    // MARK: Properties
    var view: PresenterToViewAppInfoProtocol?
    var interactor: PresenterToInteractorAppInfoProtocol?
    var router: PresenterToRouterAppInfoProtocol?
    
    func navigateToHomePage(viewController: BaseViewController) {
        router?.navigateToHomePage(viewController: viewController)
    }
}

extension AppInfoPresenter: InteractorToPresenterAppInfoProtocol {
    
}
