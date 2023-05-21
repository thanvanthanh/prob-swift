//
//  AppInfoContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewAppInfoProtocol {
   
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterAppInfoProtocol {
    
    var view: PresenterToViewAppInfoProtocol? { get set }
    var interactor: PresenterToInteractorAppInfoProtocol? { get set }
    var router: PresenterToRouterAppInfoProtocol? { get set }
    func navigateToHomePage(viewController: BaseViewController)
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorAppInfoProtocol {
    
    var presenter: InteractorToPresenterAppInfoProtocol? { get set }
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterAppInfoProtocol {
    
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterAppInfoProtocol {
    func navigateToHomePage(viewController: BaseViewController)
}
