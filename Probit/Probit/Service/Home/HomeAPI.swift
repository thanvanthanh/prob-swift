//
//  HomeAPI.swift
//  Probit
//
//  Created by Nguyen Quang on 12/09/2022.
//

import Foundation

enum WithdrawSuspendReason: String {
    case password_reset
    case otp_disable
    case primaryphoneno_removechange
}

class HomeAPI: BaseAPI<HomeServiceConfiguration> {
    static let shared = HomeAPI()
    
    func getListMaket(completionHandler: @escaping (Result<MarketResponse, ServiceError>) -> Void) {
        fetchData(configuration: .getListMaket,
                  responseType: MarketResponse.self) { result in
            completionHandler(result)
        }
    }
    
    func getPhoneNumber(completionHandler: @escaping (Result<PrimaryphoneResponse, ServiceError>) -> Void) {
        fetchData(configuration: .primaryphoneno,
                  responseType: PrimaryphoneResponse.self) { result in
            completionHandler(result)
        }
    }

    func getListIEO(completionHandler: @escaping (Result<IEOResponse, ServiceError>) -> Void) {
        fetchData(configuration: .getListIEO,
                  responseType: IEOResponse.self) { result in
            completionHandler(result)
        }
    }
    
    func getListExclusive(completionHandler: @escaping (Result<ExclusiveResponse, ServiceError>) -> Void) {
        fetchData(configuration: .getListExclusive,
                  responseType: ExclusiveResponse.self) { result in
            completionHandler(result)
        }
    }
    
    func getListAnnoucement(completionHandler: @escaping (Result<AnnoucementResponse, ServiceError>) -> Void) {
        fetchData(configuration: .getListAnnoucement,
                  responseType: AnnoucementResponse.self) { result in
            completionHandler(result)
        }
    }
    
    func getListNewCoin(completionHandler: @escaping (Result<NewCoinsResponse, ServiceError>) -> Void) {
        fetchData(configuration: .getListNewCoin,
                  responseType: NewCoinsResponse.self) { result in
            completionHandler(result)
        }
    }
    
    func getHomeConfig(completionHandler: @escaping (Result<HomeConfig, ServiceError>) -> Void) {
        fetchData(configuration: .getHomeConfig,
                  responseType: HomeConfig.self) { result in
            completionHandler(result)
        }
    }

    func getListBanner(completionHandler: @escaping (Result<BannerResponse, ServiceError>) -> Void) {
        fetchData(configuration: .listBanner,
                  responseType: BannerResponse.self) { result in
            completionHandler(result)
        }
    }
    
    func getProfileInfo(completionHandler: @escaping (Result<ProfileInfo, ServiceError>) -> Void) {
        fetchData(configuration: .me,
                  responseType: ProfileInfo.self) { result in
            completionHandler(result)
        }
    }
    
    func getProfileInfo2(completionHandler: @escaping (Result<ConfigWdwarnModel, ServiceError>) -> Void) {
        fetchData(configuration: .getConfigWdwarn,
                  responseType: ConfigWdwarnModel.self) { result in
            completionHandler(result)
        }
    }
    
    func notificationPreference(marketingPrivacy: Bool,
                                marketingMail: Bool,
                                marketingPush: Bool,
                                marketingSms: Bool,
                                nighttimePush: Bool,
                                completionHandler: @escaping (Result<NotificationPreferenceResponse, ServiceError>) -> Void) {
        fetchData(configuration: .notificationPreference(marketingPrivacy: marketingPrivacy,
                                                         marketingMail: marketingMail,
                                                         marketingPush: marketingPush,
                                                         marketingSms: marketingSms,
                                                         nighttimePush: nighttimePush),
                  responseType: NotificationPreferenceResponse.self) { result in
            completionHandler(result)
        }
    }
}
