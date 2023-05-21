//
//  StakeContract.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 22/09/2565 BE.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewStakeProtocol {
    func reloadDataTopMenu()
    func hideLoading()
    func showLoading()
    func showError(error: ServiceError)
    func showSuccess(message: String)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterStakeProtocol {
    var view: PresenterToViewStakeProtocol? { get set }
    var interactor: PresenterToInteractorStakeProtocol? { get set }
    var router: PresenterToRouterStakeProtocol? { get set }
    func didSelectMenuItem(index: IndexPath)
    func viewWillAppear()
    func getData()
    func navigateToSearch()
    var menus: [MenuBar] { get }
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorStakeProtocol {
    var presenter: InteractorToPresenterStakeProtocol? { get set }
    var menus: [MenuBar] { get set }
    var stakeList: [StakeEventModel] { get set }
    func didSelectMenuItem(index: IndexPath)
    func getStakeEvent(completed: @escaping() -> Void)
    func getStakeCurrency(completed: @escaping() -> Void)
    func getData()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterStakeProtocol {
    func changeStateMenuSuccess()
    func handerApiError(error: ServiceError)
    func changeStateResponseSucces()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterStakeProtocol {
    func navigateToSearch(stakeList: [StakeEventModel])
}
