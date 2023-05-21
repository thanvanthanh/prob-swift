//
//  HomeEntity.swift
//  Probit
//
//  Created by Nguyen Quang on 23/08/2022.
//

import Foundation

class HomeEntity: InteractorToEntityHomeProtocol {
    
    func getListMaket(completionHandler: @escaping (Result<MarketResponse, ServiceError>) -> Void) {
        HomeAPI.shared.getListMaket { result in
            completionHandler(result)
        }
    }
        
    func getListExclusive(completionHandler: @escaping (Result<ExclusiveResponse, ServiceError>) -> Void) {
        HomeAPI.shared.getListExclusive { result in
            completionHandler(result)
        }
    }
    
    func getListBanner(completionHandler: @escaping (Result<BannerResponse, ServiceError>) -> Void) {
        HomeAPI.shared.getListBanner { result in
            completionHandler(result)
        }
    }
    
    func getHomeConfig(completionHandler: @escaping (Result<HomeConfig, ServiceError>) -> Void) {
        HomeAPI.shared.getHomeConfig { result in
            completionHandler(result)
        }
    }
    
    func getListNewCoin(completionHandler: @escaping (Result<NewCoinsResponse, ServiceError>) -> Void) {
        HomeAPI.shared.getListNewCoin { result in
            completionHandler(result)
        }
    }
    
    func getListAnnoucement(completionHandler: @escaping (Result<AnnoucementResponse, ServiceError>) -> Void) {
        HomeAPI.shared.getListAnnoucement { result in
            completionHandler(result)
        }
    }
    
    func getListIEO(completionHandler: @escaping (Result<[CarouselModel], ServiceError>) -> Void) {
        HomeAPI.shared.getListIEO { result in
            switch result {
            case let .success(model):
                var carousels: [CarouselModel] = []
                model.data.forEach { key, value in
                    for (index, element) in value.imPhases.enumerated() where element.eventType != .END {
                        let uiPhase = index < value.uiPhases.count ? value.uiPhases[index] : nil
                        carousels.append(CarouselModel(uiPhase: uiPhase, articleId: key.string, model: element))
                    }
                }
                completionHandler(.success(carousels))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
}

extension HomeConfigGlobal {
    var section: HomeSection {
        HomeSection(rawValue: type) ?? .banner
    }
    
    var isShow: Bool {
        switch section {
        case .ticker:
            return content?.count == 3
        case .banner, .carousel:
            return content?.count != 0
        default:
            return true
        }
    }
}

enum HomeSection: String {
    case carousel = "carousel"
    case ticker = "ticker"
    case announcement = "announcement"
    case banner = "banner"
    case newcoin = "newcoin"
    case marketlistButton = "marketlist_button"
    case launcher = "launcher"
}

class NewCoins {
    var id: String
    let name: String?
    let urlString: String?

    var usdtRate: String? = nil
    var baseCurrencyID: String? = nil
    var quoteCurrencyID: String? = nil
    
    init(name: String?, urlString: String?, id: String) {
        self.id = id
        self.name = name
        self.urlString = urlString
    }
    
    init(model: ExchangeTicker) {
        self.id = model.baseCurrencyId.value
        self.name = model.displayName
        self.urlString = String(format: CurrencyIconType.crypto.url, id)
        self.usdtRate = model.quoteRate
        self.baseCurrencyID = model.baseCurrencyId
        self.quoteCurrencyID = model.quoteCurrencyId
    }
    
    func mapping(_ with: Usdt) {
        usdtRate = with.rate
    }
}

class CarouselModel {
    var title: String?
    var description: String?
    var eventType: StakeEventType?
    var rate: String?
    var urlLink: String?
    var bannerImage: String?
    let type: HomeBannerType
    
    let landingName: String?
    let landingIcon: String?
    let landingBanner: String?
    let landingTagline: String?
    
    init(model: Exclusive) {
        eventType = model.eventType
        type = .normal
        title = model.uiDescription.localeTitle
        bannerImage = model.uiDescription.localeBannerUrl
        description = model.eventType?.getTitle(startDate: model.startTime?.toDate(),
                                                endDate: model.endTime?.toDate())
        urlLink = String(format: AppConstant.Link.articleExclusiveLink, model.id)
        self.rate = String(format: "customview_ieocarousel_bonusbadge".Localizable(), model.rate)
        
        landingName = nil
        landingIcon = nil
        landingBanner = nil
        landingTagline = nil
    }
    
    init(uiPhase: UIDataPhasesModel?,
         articleId: String,
         model: ImPhasesModel) {
        type = .content
        title = uiPhase?.enUs?.name
        eventType = model.eventType
        bannerImage = uiPhase?.enUs?.banner
        description = model.eventType?.getTitle(startDate: model.startDate, endDate: model.endDate)
        let ver = uiPhase?.ver ?? ""
        urlLink = String(format: AppConstant.Link.articleIEOLink, articleId, ver)
        rate = String(format: "customview_ieocarousel_bonusbadge".Localizable(), model.rate)
        
        landingName = uiPhase?.enUs?.landingName
        landingIcon = uiPhase?.enUs?.landingIcon
        landingBanner = uiPhase?.enUs?.heroBg
        landingTagline = uiPhase?.enUs?.landingTagline
    }
}

struct HomeBannerModel {
    let title: String?
    let urlLink: String?
    let eventLink: String?
    let type: HomeBannerType
    let landingName: String?
    let landingIcon: String?
    let landingTagline: String?

    init(model: BannerData) {
        title = model.localeTitle
        urlLink = model.localeBannerUrl
        type = .normal
        landingName = nil
        landingIcon = nil
        landingTagline = nil
        eventLink = String(format: AppConstant.Link.articleLink, model.eventLink.value)
    }
    
    init(model: CarouselModel) {
        title = model.title
        type = model.type
        eventLink = model.urlLink
        urlLink = type == .normal ? model.urlLink : model.landingBanner
        landingName = model.landingName
        landingIcon = model.landingIcon
        landingTagline = model.landingTagline
    }
}

enum HomeBannerType {
    case content
    case normal
}
