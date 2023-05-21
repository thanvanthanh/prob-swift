//
//  TradingPrizesPageContract.swift
//  Probit
//
//  Created by Nguyen Quang on 04/10/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewTradingPrizesPageProtocol {
    func reloadData()
    func getDataSuccess()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterTradingPrizesPageProtocol {
    var view: PresenterToViewTradingPrizesPageProtocol? { get set }
    var interactor: PresenterToInteractorTradingPrizesPageProtocol? { get set }
    var router: PresenterToRouterTradingPrizesPageProtocol? { get set }
    var tradingDetail: TradingDetail? { get set }
    var menus: [MenuBar] { get set }
    var title: String? { get }

    func viewDidLoad()
    func didSelectMenuItem(index: IndexPath)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorTradingPrizesPageProtocol {
    var presenter: InteractorToPresenterTradingPrizesPageProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterTradingPrizesPageProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterTradingPrizesPageProtocol {
}
