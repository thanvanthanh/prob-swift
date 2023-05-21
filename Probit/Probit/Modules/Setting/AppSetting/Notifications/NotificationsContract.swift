//
//  NotificationsContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 27/09/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewNotificationsProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterNotificationsProtocol {
    var view: PresenterToViewNotificationsProtocol? { get set }
    var interactor: PresenterToInteractorNotificationsProtocol? { get set }
    var router: PresenterToRouterNotificationsProtocol? { get set }
    func navigateToSystemSetting()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorNotificationsProtocol {
    var presenter: InteractorToPresenterNotificationsProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterNotificationsProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterNotificationsProtocol {
    func navigateToSystemSetting()
}
