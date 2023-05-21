//
//  MaintenancePresenter.swift
//  Probit
//
//  Created by Bradley Hoang on 31/10/2022.
//  
//

import Foundation

class MaintenancePresenter: ViewToPresenterMaintenanceProtocol {
    // MARK: Properties
    var view: PresenterToViewMaintenanceProtocol?
    var interactor: PresenterToInteractorMaintenanceProtocol?
    var router: PresenterToRouterMaintenanceProtocol?
    
    var runtimeConfig: RuntimeConfig? {
        return interactor?.runtimeConfig
    }
}

extension MaintenancePresenter: InteractorToPresenterMaintenanceProtocol {
    
}
