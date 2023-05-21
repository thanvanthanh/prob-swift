//
//  ThirdPartyListContract.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/12/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewThirdPartyListProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterThirdPartyListProtocol {
    var view: PresenterToViewThirdPartyListProtocol? { get set }
    var interactor: PresenterToInteractorThirdPartyListProtocol? { get set }
    var router: PresenterToRouterThirdPartyListProtocol? { get set }
    func navigateToDetail(html: String)
    var listThirdParty: [ThirdParty] { get }
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorThirdPartyListProtocol {
    var presenter: InteractorToPresenterThirdPartyListProtocol? { get set }
    var listThirdParty: [ThirdParty] { get }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterThirdPartyListProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterThirdPartyListProtocol {
    func navigateToDetail(html: String)
}
