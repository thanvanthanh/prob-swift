//
//  ThirdPartyDetailContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/12/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewThirdPartyDetailProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterThirdPartyDetailProtocol {
    var view: PresenterToViewThirdPartyDetailProtocol? { get set }
    var interactor: PresenterToInteractorThirdPartyDetailProtocol? { get set }
    var router: PresenterToRouterThirdPartyDetailProtocol? { get set }
    func navigateToWeb(url: URL)
    var html: String? { get set }
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorThirdPartyDetailProtocol {
    var presenter: InteractorToPresenterThirdPartyDetailProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterThirdPartyDetailProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterThirdPartyDetailProtocol {
    func navigateToWeb(url: URL)
}
