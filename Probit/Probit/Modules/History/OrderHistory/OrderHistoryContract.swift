//
//  OrderHistoryContract.swift
//  Probit
//
//  Created by Nguyen Quang on 29/08/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewOrderHistoryProtocol {
    func hideLoading()
    func showLoading()
    func reloadData()
    func loadData()
    func showError(error: ServiceError)
    func showSuccess(message: String)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterOrderHistoryProtocol {
    var view: PresenterToViewOrderHistoryProtocol? { get set }
    var interactor: PresenterToInteractorOrderHistoryProtocol? { get set }
    var router: PresenterToRouterOrderHistoryProtocol? { get set }
    func viewWillAppear()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorOrderHistoryProtocol {
    var presenter: InteractorToPresenterOrderHistoryProtocol? { get set }
    var orders: [OrderDataModel] { get }
    func getData()
    var filterModel: SearchFilterModel { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterOrderHistoryProtocol {
    func handerApiError(error: ServiceError)
    func changeStateResponseSucces()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterOrderHistoryProtocol {
}
