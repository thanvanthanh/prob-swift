//
//  OpenOrdersContract.swift
//  Probit
//
//  Created by Nguyen Quang on 29/08/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewOpenOrdersProtocol {
    func hideLoading()
    func showLoading()
    func reloadData()
    func loadData()
    func showError(error: ServiceError)
    func showSuccess(message: String)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterOpenOrdersProtocol {
    var view: PresenterToViewOpenOrdersProtocol? { get set }
    var interactor: PresenterToInteractorOpenOrdersProtocol? { get set }
    var router: PresenterToRouterOpenOrdersProtocol? { get set }
    var screenType: OpenOrdersType? { get set }
    var orderOpens: [OrderDataModel] { get }
    var delegate: OpenOrdersDelegate? { set get }
    func viewWillAppear(hidePair: Bool)
    func doCancelOrder(openOrder: OrderDataModel, hidePair: Bool)
    func doCancelAllOrder(hidePair: Bool)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorOpenOrdersProtocol {
    var presenter: InteractorToPresenterOpenOrdersProtocol? { get set }
    var orderOpens: [OrderDataModel] { get }
    var pair: String? { get set }
    func getData(hidePair: Bool)
    func doCancelOrder(openOrder: OrderDataModel, hidePair: Bool)
    func doCancelAllOrder(hidePair: Bool)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterOpenOrdersProtocol {
    func handerApiError(error: ServiceError)
    func changeStateResponseSucces()
    func cancelOrderSucess(hidePair: Bool, orderDatas: [OrderDataEntry])
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterOpenOrdersProtocol {
}
