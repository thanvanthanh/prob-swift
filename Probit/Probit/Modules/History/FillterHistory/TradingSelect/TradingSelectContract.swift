//
//  TradingSelectContract.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 14/10/2565 BE.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewTradingSelectProtocol {
    func reloadData()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterTradingSelectProtocol {
    var view: PresenterToViewTradingSelectProtocol? { get set }
    var interactor: PresenterToInteractorTradingSelectProtocol? { get set }
    var router: PresenterToRouterTradingSelectProtocol? { get set }
    func filterData(searchText: String)
    func viewDidLoad()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorTradingSelectProtocol {
    var presenter: InteractorToPresenterTradingSelectProtocol? { get set }
    func filterData(searchText: String)
    var delegate: TradingSelectViewControllerDelegate { get set }
    var listFilted: [ItemSelectModel] { get }
    var listData: [ItemSelectModel] { get }
    func itemSelected() -> ItemSelectModel?
    var typeList: String { get }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterTradingSelectProtocol {
    func dataListDidFetch()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterTradingSelectProtocol {
}

protocol TradingSelectViewControllerDelegate {
    func listData(type: String) -> [ItemSelectModel]
    func itemSelected(type: String) -> ItemSelectModel?
    func updateSelected(type: String, itemSelected: ItemSelectModel?)
}

struct ItemSelectModel {
    var title: String
    var subTitle: String
    var id: String
}
