//
//  TradeHistoryContract.swift
//  Probit
//
//  Created by Nguyen Quang on 29/08/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewTradeHistoryProtocol {
    func hideLoading()
    func showLoading()
    func reloadView()
    func loadDataToView()
    func showError(error: ServiceError)
    func showSuccess(message: String)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterTradeHistoryProtocol {
    var view: PresenterToViewTradeHistoryProtocol? { get set }
    var interactor: PresenterToInteractorTradeHistoryProtocol? { get set }
    var router: PresenterToRouterTradeHistoryProtocol? { get set }
    func viewWillAppear()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorTradeHistoryProtocol {
    var presenter: InteractorToPresenterTradeHistoryProtocol? { get set }
    func getData()
    var filterModel: SearchFilterModel { get set}
    var tradeHistorys: [TradeHistoryModel] { get }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterTradeHistoryProtocol {
    func handerApiError(error: ServiceError)
    func changeStateResponseSucces()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterTradeHistoryProtocol {
}
