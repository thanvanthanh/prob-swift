//
//  ExchangeContract.swift
//  Probit
//
//  Created by Nguyen Quang on 25/08/2022.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewExchangeProtocol: BaseViewProtocol {
    func reloadData()
    func getDataSuccess()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterExchangeProtocol {
    var view: PresenterToViewExchangeProtocol? { get set }
    var interactor: PresenterToInteractorExchangeProtocol? { get set }
    var router: PresenterToRouterExchangeProtocol? { get set }
    
    var listExchange: [MenuBar] { get }

    var exchanges: [ExchangeTicker] { get }
    var btcExchanges: [ExchangeTicker] { get }
    var ethExchanges: [ExchangeTicker] { get }
    var usdtExchanges: [ExchangeTicker] { get }
    var defiExchanges: [ExchangeTicker] { get }
    var favoriteExchanges: [ExchangeTicker] { get }
    
    var usdtContent: ExchangePageViewViewController? { get }
    var btcContent: ExchangePageViewViewController? { get }
    var ethContent: ExchangePageViewViewController? { get }
    var defiContent: ExchangePageViewViewController? { get }
    var favoriteContent: ExchangePageViewViewController? { get }

    var sortType: ExchangeSortType { get }
    var sortCompare: ExchangeSortCompare { get }
    
    func disconnectSocket()
    func subscribeSocket()
    func viewDidLoad()
    func viewWillAppear()
    func selectedExchange(index: IndexPath)
    func sortVolumeData()
    func sortChange24HrData()
    func sortPriceData()
    func sortTradingPairData()
    func navigateToSearchExchange()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorExchangeProtocol {
    var presenter: InteractorToPresenterExchangeProtocol? { get set }
    var entity: InteractorToEntityExchangeProtocol? { get set }
    
    var listExchange: [MenuBar] { get set }
    var sortType: ExchangeSortType { get set }
    var sortCompare: ExchangeSortCompare { get set }
    
    var btcExchanges: [ExchangeTicker] { get set }
    var ethExchanges: [ExchangeTicker] { get set }
    var usdtExchanges: [ExchangeTicker] { get set }
    var defiExchanges: [ExchangeTicker]  { get set }
    var favoriteExchanges: [ExchangeTicker]  { get set }
    
    var exchanges: [ExchangeTicker] { get set }
    
    func getData()
    func selectedExchange(index: IndexPath)
    func sortVolumeData()
    func sortChange24HrData()
    func sortPriceData()
    func sortTradingPairData()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterExchangeProtocol {
    func dataListDidFetch()
    func changeExchangeSuccess()
    func connectSocket()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterExchangeProtocol {
    func navigateToSearchExchange(data: [ExchangeTicker])
}

protocol InteractorToEntityExchangeProtocol {
 
}
