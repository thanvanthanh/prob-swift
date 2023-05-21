//
//  TradingCompetitionContract.swift
//  Probit
//
//  Created by Nguyen Quang on 22/09/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewTradingCompetitionProtocol: BaseViewProtocol {
    func reloadData()
    func getDataSuccess()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterTradingCompetitionProtocol {
    var view: PresenterToViewTradingCompetitionProtocol? { get set }
    var interactor: PresenterToInteractorTradingCompetitionProtocol? { get set }
    var router: PresenterToRouterTradingCompetitionProtocol? { get set }
    var menus: [MenuBar] { get }
    var tradings: [Trading] { get }

    func viewDidLoad()
    func didSelectMenuItem(index: IndexPath)
    func navigateToTradingSearch()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorTradingCompetitionProtocol {
    var menus: [MenuBar] { get set }
    var tradings: [Trading] { get set }
    var presenter: InteractorToPresenterTradingCompetitionProtocol? { get set }
    var entity: InteractorToEntityTradingCompetitionProtocol? { get set }
    
    func getData()
    func didSelectMenuItem(index: IndexPath)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterTradingCompetitionProtocol {
    func changeStateMenuSuccess()
    func getListTradingSuccess()
    
    func handerApiError(error: ServiceError)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterTradingCompetitionProtocol {
    func navigateToTradingSearch(data: [Trading])
    
}

protocol InteractorToEntityTradingCompetitionProtocol {
    func getListTradecompetition(completionHandler: @escaping (Result<TradingResponse, ServiceError>) -> Void)
}
