//
//  HomeServiceConfiguration.swift
//  Probit
//
//  Created by Nguyen Quang on 12/09/2022.
//

import Foundation
import Alamofire

enum HomeServiceConfiguration {
    case listBanner
    case me
    case notificationPreference(marketingPrivacy: Bool,
                                marketingMail: Bool,
                                marketingPush: Bool,
                                marketingSms: Bool,
                                nighttimePush: Bool)
    case getHomeConfig
    case getListNewCoin
    case getListAnnoucement
    case getListExclusive
    case getListIEO
    case getListMaket
    case getConfigWdwarn
    case primaryphoneno
}

extension HomeServiceConfiguration: Configuration {
    var baseURL: String {
        switch self {
        case .me:
            return Constant.Server.baseAPIURL
        case .notificationPreference, .getListAnnoucement, .getListExclusive, .getListIEO, .getListMaket, .listBanner:
            return Constant.Server.baseAPIURL
        case .getListNewCoin:
            return Constant.Server.baseStaticURL
        case .getHomeConfig:
            return Constant.Server.baseStaticURL
        case .getConfigWdwarn:
            return Constant.Server.baseStaticURL
        case .primaryphoneno:
            return Constant.Server.baseAPIURL
        }
    }
    
    var path: String {
        switch self {
        case .listBanner:
            return "api/event/v1/list"
        case .me:
            return "api/account/v1/me"
        case .primaryphoneno:
            return "api/account/v1/primaryphoneno"
        case .notificationPreference:
            return "api/account/v1/notification_preference"
        case .getHomeConfig:
            return "ua-cfg/iosapp-home-config.json"
        case .getListNewCoin:
            return "ua-cfg/coin-info-config.json"
        case .getListAnnoucement:
            return "api/help-center/v1/articles"
        case .getListExclusive:
            return "api/event/v1/probitexclusive/config"
        case .getListIEO:
            return "api/ieo/v1/projects/list"
        case .getListMaket:
            return "api/exchange/v1/market"
        case .getConfigWdwarn:
            return "ua-cfg/wdwarn.\(AppConstant.locale).json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .listBanner, .getHomeConfig, .me, .getListNewCoin,
                .getListAnnoucement, .getListExclusive,
                .getListIEO, .getListMaket, .getConfigWdwarn:
            return .get
        case .notificationPreference:
            return .post
        case .primaryphoneno:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .listBanner:
            return .requestParameters(parameters: ["service": "global",
                                                   "locale": AppConstant.locale,
                                                   "display_on": "landing",
                                                   "status": "running",
                                                   "type": "info,events,exclusive"])
        case .notificationPreference(let marketingPrivacy,
                                     let marketingMail,
                                     let marketingPush,
                                     let marketingSms,
                                     let nighttimePush):
            return .requestParameters(parameters: ["marketing_privacy": marketingPrivacy,
                                                   "nighttime_push": nighttimePush,
                                                   "marketing_sms": marketingSms,
                                                   "marketing_push": marketingPush,
                                                   "marketing_mail": marketingMail])
        case .getListAnnoucement:
            return .requestParameters(parameters: ["locale": AppConstant.locale,
                                                   "category": "announcements",
                                                   "sort": "publish_date",
                                                   "sort_order": "DESC",
                                                   "pinned": false])
        case .primaryphoneno:
            return .requestParameters(parameters: ["unmask": true])
        case .me, .getHomeConfig, .getListNewCoin, .getConfigWdwarn,
                .getListExclusive, .getListIEO, .getListMaket:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            guard let token = AppConstant.accessToken else { return [:] }
            return ["Authorization": "Bearer \(token)"]
        }
    }
    
    var data: Data? {
        return nil
    }
    
}
