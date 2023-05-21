//
//  PurchaseHistoryContract.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 19/10/2565 BE.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewPurchaseHistoryProtocol {
    func showLoading()
    func hideLoading()
    func updateUI()
    func showError(error: ServiceError)
    func showSuccess(message: String)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterPurchaseHistoryProtocol {
    var view: PresenterToViewPurchaseHistoryProtocol? { get set }
    var interactor: PresenterToInteractorPurchaseHistoryProtocol? { get set }
    var router: PresenterToRouterPurchaseHistoryProtocol? { get set }
    func viewDidLoad()

}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorPurchaseHistoryProtocol {
    var listPurChaseModel: [PurchaseModel] { get }
    var presenter: InteractorToPresenterPurchaseHistoryProtocol? { get set }
    func getData()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterPurchaseHistoryProtocol {
    func getDataSuccess()
    func getDataFailed(_ error: ServiceError)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterPurchaseHistoryProtocol {
}
