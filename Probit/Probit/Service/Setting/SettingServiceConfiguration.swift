//
//  SettingServiceConfiguration.swift
//  Probit
//
//  Created by Thân Văn Thanh on 29/09/2022.
//

import Foundation
import Alamofire

enum SettingServiceConfiguration {
    case membership
    case referrerCount
    case getPayInProb
    case postPayInProb(params: Bool)
    case checkStep
    case userKycStatus
    case referrerCode
    case referrerEarned
    case notificationPreference(terms: TermSetting)
    case getRuntimeConfig
    case getCountryNames(locale: String)
    case getListKycCountries
    case getListIneligibleKycCountries
    case globalKycData(page: UserKycStatusDetailModel.PageType)
    case updateDataKyc(data: [String: String])
    case validatePageKyc(page: UserKycStatusDetailModel.PageType)
    case uploadImage(image: UIImage)
    case deleteImage(name: String)
    case nextStep(step: String)
}

extension SettingServiceConfiguration: Configuration {
    var baseURL: String {
        switch self {
        case .getRuntimeConfig, .getCountryNames:
            return Constant.Server.baseStaticURL
        default:
            return Constant.Server.baseAPIURL
        }
    }
    
    var path: String {
        switch self {
        case .membership:
            return "api/account/v1/membership"
        case .referrerCount:
            return "api/referrer/v1/count"
        case .getPayInProb, .postPayInProb:
            return "api/account/v1/pay_in_prob"
        case .checkStep:
            return "api/account/v1/global_kyc/checkstep"
        case .userKycStatus:
            return "api/account/v1/global_kyc/argos/v2/status"
        case .referrerCode:
             return "api/referrer/v1/code"
        case .referrerEarned:
            return "api/referrer/v1/earned"
        case .notificationPreference:
            return "api/account/v1/notification_preference"
        case .getRuntimeConfig:
            return "ua-cfg/iosapp-config.json"
        case .getListKycCountries:
            return "api/account/v1/global_kyc/argos/v2/country_list"
        case .getListIneligibleKycCountries:
            return "api/account/v1/global_kyc/argos/v2/ineligible_countries_list"
        case let .getCountryNames(locale):
            return "common/locale_data/country_name/\(locale).json"
        case .globalKycData:
            return "api/account/v1/global_kyc/data"
        case .updateDataKyc:
            return "api/account/v1/global_kyc/data"
        case .validatePageKyc:
            return "api/account/v1/global_kyc/page"
        case .deleteImage(let name):
            return "api/account/v1/global_kyc/data/image/\(name)"
        case .uploadImage:
            return "api/account/v1/global_kyc/data/image"
        case .nextStep(let step):
            return "api/account/v1/global_kyc/argos/v2/\(step)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .membership, .getPayInProb, .checkStep, .userKycStatus,
                .getRuntimeConfig, .getListKycCountries,
                .getListIneligibleKycCountries, .getCountryNames, .globalKycData:
            return .get
        case .referrerEarned, .referrerCount, .referrerCode:
            return .get
        case .postPayInProb, .notificationPreference, .nextStep,
                .updateDataKyc, .validatePageKyc, .uploadImage:
            return .post
        case .deleteImage:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .membership, .getPayInProb, .checkStep,
                .userKycStatus, .referrerCount,
                .referrerCode, .referrerEarned, .deleteImage:
            return .requestParameters(parameters: [:])
        case .postPayInProb(let param):
            let value = param ? "on" : "off"
            return .requestParameters(parameters: ["pay_in_prob":value])
        case .notificationPreference(let terms):
            return .requestParameters(parameters: terms.params)
        case .getRuntimeConfig, .getListKycCountries, .getListIneligibleKycCountries, .getCountryNames:
            return .requestPlain
        case .globalKycData(let page):
            return .requestParameters(parameters: ["page": page.rawValue])
        case .updateDataKyc(let data):
            return .requestParameters(parameters: data)
        case .validatePageKyc(let page):
            return .requestParameters(parameters: ["page": page.rawValue])
        case .uploadImage, .nextStep:
            return .requestParameters(parameters: [:])
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .membership, .checkStep, .userKycStatus,
                .referrerCount, .referrerCode,
                .referrerEarned, .globalKycData,
                .updateDataKyc, .validatePageKyc, .deleteImage, .uploadImage:
            return AppConstant.authorizationHeader
        default:
            return [:]
        }
    }
    
    var data: Data? {
        switch self {
        case .uploadImage(let image):
            return image.jpegData(compressionQuality: 1)
        default:
            return nil
        }
    }
}
