//
//  AppLockPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 27/09/2022.
//  
//

import Foundation

class AppLockPresenter: ViewToPresenterAppLockProtocol {
    // MARK: Properties
    var view: PresenterToViewAppLockProtocol?
    var interactor: PresenterToInteractorAppLockProtocol?
    var router: PresenterToRouterAppLockProtocol?
    
    func navigateToInputPin(type: InputPinType) {
        router?.navigateToInputPin(type: type)
    }
}

extension AppLockPresenter: InteractorToPresenterAppLockProtocol {
    
}
