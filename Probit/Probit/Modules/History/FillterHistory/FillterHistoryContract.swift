//
//  FillterHistoryContract.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 12/10/2565 BE.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewFillterHistoryProtocol {
    func hideLoading()
    func showLoading()
    func showError(error: ServiceError)
    func showSuccess(message: String)
    func reloadData()
    func bindDataView()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterFillterHistoryProtocol {
    var view: PresenterToViewFillterHistoryProtocol? { get set }
    var interactor: PresenterToInteractorFillterHistoryProtocol? { get set }
    var router: PresenterToRouterFillterHistoryProtocol? { get set }
    func viewDidLoad()
    var isHideCurrencyView: Bool? { get set }
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorFillterHistoryProtocol {
    var presenter: InteractorToPresenterFillterHistoryProtocol? { get set }
    var currencies: [Currency] { get }
    var marketsInfo: [MarketInfo] { get }
    var markets: [Market] { get }
    var listQuoteCurrencyId: [String] { get }
    func getData()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterFillterHistoryProtocol {
    func handerApiError(error: ServiceError)
    func changeStateResponseSucces()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterFillterHistoryProtocol {
}
