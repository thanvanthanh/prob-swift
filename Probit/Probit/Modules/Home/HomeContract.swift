//
//  HomeContract.swift
//  Probit
//
//  Created by Nguyen Quang on 23/08/2022.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewHomeProtocol: BaseViewProtocol {
    func getHomeConfigComplete(exchangeRate: ExchangeRate?, marketData: MarketData?)
    func setupNavigationBar()
    func bindData(indexPaths: [Int], exchangeRate: ExchangeRate?, marketData: MarketData?)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterHomeProtocol {
    var view: PresenterToViewHomeProtocol? { get set }
    var interactor: PresenterToInteractorHomeProtocol? { get set }
    var router: PresenterToRouterHomeProtocol? { get set }
    
    var newCoins: [NewCoins] { get }
    var listBanner: [HomeBannerModel] { get }
    var homeSectionData: [HomeConfigGlobal] { get }
    var annoucements: [Annoucement] { get }
    var carousels: [CarouselModel] { get }
    var makets: [Market] { get }

    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func navigateToBuyCrypto()
    func navigateToLogin()
    func navigateToMore()
    func navigateToWebView(link: String, title: String)
    func navigateToAppLock()
    func navigateToExchange(from vc: UIViewController)
    func navigateToExchangeDetail(with market: Market?)
    func navigateToExchangeDetail(with exchangeId: String)
    func selectNewCoin(_ coin: NewCoins)
    func networkDisconnected()
    func networkRecconnected()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorHomeProtocol {
    var presenter: InteractorToPresenterHomeProtocol? { get set }
    var entity: InteractorToEntityHomeProtocol? { get set }
    
    var newCoins: [NewCoins] { get set }
    var listBanner: [HomeBannerModel] { get set }
    var homeSectionData: [HomeConfigGlobal] { get set }
    var annoucements: [Annoucement] { get set }
    var carousels: [CarouselModel] { get set }
    var makets: [Market] { get set }
    func getData()
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterHomeProtocol {
    func getHomeConfigComplete()
    func getCoinInfoComplete()
    func handerApiError()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterHomeProtocol {
    func navigateToBuyCrypto()
    func navigateToLogin()
    func navigateToMore()
    func navigateToWebView(link: String, title: String)
    func navigateToAppLock()
    func navigateToExchange(from vc: UIViewController)
    func navigateToExchangeSearch(keyword: String)
    func navigateToExchangeDetail(with exchangeTicker: ExchangeTicker)
    func navigateToExchangeDetail(with exchangeId: String)
}

protocol InteractorToEntityHomeProtocol {
    func getListMaket(completionHandler: @escaping (Result<MarketResponse, ServiceError>) -> Void)
    func getListIEO(completionHandler: @escaping (Result<[CarouselModel], ServiceError>) -> Void)
    func getHomeConfig(completionHandler: @escaping (Result<HomeConfig, ServiceError>) -> Void)
    func getListBanner(completionHandler: @escaping (Result<BannerResponse, ServiceError>) -> Void)
    func getListNewCoin(completionHandler: @escaping (Result<NewCoinsResponse, ServiceError>) -> Void)
    func getListExclusive(completionHandler: @escaping (Result<ExclusiveResponse, ServiceError>) -> Void)
    func getListAnnoucement(completionHandler: @escaping (Result<AnnoucementResponse, ServiceError>) -> Void)
}
