//
//  HomeInteractor.swift
//  Probit
//
//  Created by Nguyen Quang on 23/08/2022.
//  
//

import Foundation

class HomeInteractor: PresenterToInteractorHomeProtocol {
    var newCoins: [NewCoins] = []
    var listBanner: [HomeBannerModel] = []
    var annoucements: [Annoucement] = []
    var carousels: [CarouselModel] = []
    var makets: [Market] = []
    var tickers: [Ticker] = []
    var homeSectionData: [HomeConfigGlobal] = []
    var getTicker: GetTickerAction = GetTickerAction(dataSource: GatewayApiProductService())

    // MARK: Properties
    var presenter: InteractorToPresenterHomeProtocol?
    var entity: InteractorToEntityHomeProtocol?
    
    func getData() {
        getHomeConfig()
    }
    
    func getHomeConfig() {
        var currentCarousels: [CarouselModel] = []
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        entity?.getHomeConfig(completionHandler: { [weak self] result in
            dispatchGroup.leave()
            guard let `self` = self else { return }
            switch result {
            case let .success(model):
                self.homeSectionData = model.global.filter { $0.isShow }
            case .failure:
                self.presenter?.handerApiError()
            }
        })
        dispatchGroup.enter()
        entity?.getListBanner(completionHandler: { [weak self] result in
            dispatchGroup.leave()
            guard let `self` = self else { return }
            switch result {
            case let .success(model):
                self.listBanner = model.data.map { HomeBannerModel(model: $0) }
            case .failure:
                self.presenter?.handerApiError()
            }
        })
        dispatchGroup.enter()
        entity?.getListAnnoucement(completionHandler: { [weak self] result in
            dispatchGroup.leave()
            guard let `self` = self else { return }
            switch result {
            case let .success(model):
                self.annoucements = model.data
            case .failure:
                self.presenter?.handerApiError()
            }
        })
        dispatchGroup.enter()
        entity?.getListExclusive(completionHandler: { [weak self] result in
            dispatchGroup.leave()
            guard let `self` = self else { return }
            switch result {
            case let .success(model):
                let carousels = model.data.compactMap { $0.eventType != .END ? CarouselModel(model: $0) : nil }
                currentCarousels.append(contentsOf: carousels)
            case .failure:
                self.presenter?.handerApiError()
            }
        })
        dispatchGroup.enter()
        entity?.getListIEO(completionHandler: { [weak self] result in
            dispatchGroup.leave()
            guard let `self` = self else { return }
            switch result {
            case let .success(model):
                currentCarousels.append(contentsOf: model)
            case .failure:
                self.presenter?.handerApiError()
            }
        })
        dispatchGroup.enter()
        entity?.getListMaket(completionHandler: { [weak self] result in
            dispatchGroup.leave()
            guard let self = self else { return }
            switch result {
            case let .success(model):
                self.makets = model.data
                break
            case .failure(let error):
                print(error.message)
                self.presenter?.handerApiError()
            }
        })
        dispatchGroup.enter()
        getTicker.apiCall { [weak self] result in
            dispatchGroup.leave()
            guard let self = self else { return }
            switch result {
            case .success(let res):
                self.tickers = res.data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            guard let `self` = self else { return }
            self.makets.forEach {
                $0.mapping(withTicker: self.tickers)
            }
            self.carousels = currentCarousels
            self.listBanner.append(contentsOf: self.carousels.map { HomeBannerModel(model: $0) })
            self.removeEmptySection()
            self.presenter?.getHomeConfigComplete()
            self.getCoinInfo()
        })
    }
    
    func getCoinInfo() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        entity?.getListNewCoin(completionHandler: { [weak self] result in
            dispatchGroup.leave()
            guard let `self` = self else { return }
            switch result {
            case let .success(model):
                self.newCoins = model.newListings.prefix(10).compactMap {
                    guard let coinInfo = model.coinInfo[$0] else { return nil }
                    return NewCoins(name: coinInfo?.displayName?.localized,
                                    urlString: coinInfo?.logourl, id: $0)
                }
            case .failure:
                self.presenter?.handerApiError()
            }
        })
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            guard let `self` = self else { return }
            self.presenter?.getCoinInfoComplete()
        })
    }
    
    func removeEmptySection() {
        if let index = homeSectionData.firstIndex(where: { $0.section == .banner }), listBanner.isEmpty {
            homeSectionData.remove(at: index)
        }
        if let index = homeSectionData.firstIndex(where: { $0.section == .announcement }), annoucements.isEmpty {
            homeSectionData.remove(at: index)
        }
        if let index = homeSectionData.firstIndex(where: { $0.section == .carousel }), carousels.isEmpty {
            homeSectionData.remove(at: index)
        }
    }
}
