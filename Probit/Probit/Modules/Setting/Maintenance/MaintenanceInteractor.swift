//
//  MaintenanceInteractor.swift
//  Probit
//
//  Created by Bradley Hoang on 31/10/2022.
//  
//

import Foundation

class MaintenanceInteractor: PresenterToInteractorMaintenanceProtocol {    
    // MARK: Properties
    var presenter: InteractorToPresenterMaintenanceProtocol?
    
    var runtimeConfig: RuntimeConfig?
}
