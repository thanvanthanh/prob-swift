//
//  ThirdPartyContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/12/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewThirdPartyProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterThirdPartyProtocol {
    var view: PresenterToViewThirdPartyProtocol? { get set }
    var interactor: PresenterToInteractorThirdPartyProtocol? { get set }
    var router: PresenterToRouterThirdPartyProtocol? { get set }
    func navigateToWeb(url: URL)
    func navigateToList()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorThirdPartyProtocol {
    var presenter: InteractorToPresenterThirdPartyProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterThirdPartyProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterThirdPartyProtocol {
    func navigateToWeb(url: URL)
    func navigateToList()
}
