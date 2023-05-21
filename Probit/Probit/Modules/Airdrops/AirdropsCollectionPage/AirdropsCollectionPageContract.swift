//
//  AirdropsCollectionPageContract.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 26/12/2565 BE.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewAirdropsCollectionPageProtocol {
    func reloadData()
    func hideLoading()
    func showLoading()
    func showError(error: ServiceError)
    func showSuccess(message: String)
    func showFooterLoadMore()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterAirdropsCollectionPageProtocol {
    var view: PresenterToViewAirdropsCollectionPageProtocol? { get set }
    var interactor: PresenterToInteractorAirdropsCollectionPageProtocol? { get set }
    var router: PresenterToRouterAirdropsCollectionPageProtocol? { get set }
    func loadMore()
    func viewDidLoad()

}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorAirdropsCollectionPageProtocol {
    var presenter: InteractorToPresenterAirdropsCollectionPageProtocol? { get set }
    var listAirdrop: [EventAirdropModel] { get }
    func getData()
    func nextPage()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterAirdropsCollectionPageProtocol {
    func handerApiError(error: ServiceError)
    func getListAirdropSucces()
    func pageNotEmpty()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterAirdropsCollectionPageProtocol {
}
