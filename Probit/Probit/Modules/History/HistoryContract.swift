//
//  HistoryContract.swift
//  Probit
//
//  Created by Nguyen Quang on 29/08/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewHistoryProtocol {
    func reloadData()
    func getDataSuccess()
    func loadDataPageView(page: Int?)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterHistoryProtocol {
    var view: PresenterToViewHistoryProtocol? { get set }
    var interactor: PresenterToInteractorHistoryProtocol? { get set }
    var router: PresenterToRouterHistoryProtocol? { get set }
    
    var menus: [MenuBar] { get }
    var currentPage: Int { get }
    func viewDidLoad()
    func didSelectMenuItem(index: IndexPath)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorHistoryProtocol {
    var presenter: InteractorToPresenterHistoryProtocol? { get set }
    var menus: [MenuBar] { get set }
    var currentPage: Int { get set }
    func getData()
    func didSelectMenuItem(index: IndexPath)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterHistoryProtocol {
    func dataListDidFetch()
    func changeStateMenuSuccess()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterHistoryProtocol {
}
