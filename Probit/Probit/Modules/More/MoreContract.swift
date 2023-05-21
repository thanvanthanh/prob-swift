//
//  MoreContract.swift
//  Probit
//
//  Created by Nguyen Quang on 21/09/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewMoreProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterMoreProtocol {
    var view: PresenterToViewMoreProtocol? { get set }
    var interactor: PresenterToInteractorMoreProtocol? { get set }
    var router: PresenterToRouterMoreProtocol? { get set }
    
    var mores: [MoreItem] { get }
    func navigateNextScreen(type: MoreItem, viewController: BaseViewController)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorMoreProtocol {
    var presenter: InteractorToPresenterMoreProtocol? { get set }
    var mores: [MoreItem] { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterMoreProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterMoreProtocol {
    func navigateNextScreen(type: MoreItem, viewController: BaseViewController)
}
