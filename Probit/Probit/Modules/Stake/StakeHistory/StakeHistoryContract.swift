//
//  StakeHistoryContract.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 06/10/2565 BE.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewStakeHistoryProtocol {
    func reloadDataTopMenu()
    func hideLoading()
    func showLoading()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterStakeHistoryProtocol {
    var view: PresenterToViewStakeHistoryProtocol? { get set }
    var interactor: PresenterToInteractorStakeHistoryProtocol? { get set }
    var router: PresenterToRouterStakeHistoryProtocol? { get set }
    var menus: [MenuBar] { get }
    func viewDidLoad()
    func didSelectMenuItem(index: IndexPath)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorStakeHistoryProtocol {
    var presenter: InteractorToPresenterStakeHistoryProtocol? { get set }
    func getData()
    var menus: [MenuBar] { get set }
    func didSelectMenuItem(index: IndexPath)
    var interactorDetail: StakeDetailsInteractorProtocol { get }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterStakeHistoryProtocol {
    func handerApiError(error: ServiceError)
    func changeStateMenuSuccess()
    func changeStateResponseSucces()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterStakeHistoryProtocol {
}
