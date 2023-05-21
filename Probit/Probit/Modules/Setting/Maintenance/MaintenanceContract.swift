//
//  MaintenanceContract.swift
//  Probit
//
//  Created by Bradley Hoang on 31/10/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewMaintenanceProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterMaintenanceProtocol {
    var view: PresenterToViewMaintenanceProtocol? { get set }
    var interactor: PresenterToInteractorMaintenanceProtocol? { get set }
    var router: PresenterToRouterMaintenanceProtocol? { get set }
    
    var runtimeConfig: RuntimeConfig? { get }
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorMaintenanceProtocol {
    var presenter: InteractorToPresenterMaintenanceProtocol? { get set }
    
    var runtimeConfig: RuntimeConfig? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterMaintenanceProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterMaintenanceProtocol {
}
