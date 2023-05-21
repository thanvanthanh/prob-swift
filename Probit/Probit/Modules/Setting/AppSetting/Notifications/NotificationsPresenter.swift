//
//  NotificationsPresenter.swift
//  Probit
//
//  Created by Thân Văn Thanh on 27/09/2022.
//  
//

import Foundation

class NotificationsPresenter: ViewToPresenterNotificationsProtocol {
    // MARK: Properties
    var view: PresenterToViewNotificationsProtocol?
    var interactor: PresenterToInteractorNotificationsProtocol?
    var router: PresenterToRouterNotificationsProtocol?
    
    func navigateToSystemSetting() {
        router?.navigateToSystemSetting()
    }
}

extension NotificationsPresenter: InteractorToPresenterNotificationsProtocol {
    
}
