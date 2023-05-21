//
//  TermsAndPolicies.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//

import Foundation

class AppSettingTermsAndPoliciesEntity: InteractorToEntityAppSettingTermsAndPoliciesProtocol {
    func notificationPreference(terms: TermSetting,
                                completionHandler: @escaping (Result<NotificationPreferenceResponse, ServiceError>) -> Void) {
        SettingAPI().notificationPreference(terms: terms, completionHandler: { result in
            completionHandler(result)
        })
    }
}

struct TermsAndPolicies {
    var title: TermsAndPoliciesType
    var model: [TermSetting]
    
    init(title: TermsAndPoliciesType,
         model:[TermSetting] = []) {
        self.title = title
        self.model = model
    }
}

enum TermsAndPoliciesType: CaseIterable {
    case persional
    case notification
    case privacy
    case terms
    case thirdParty
    
    var title: String {
        switch self {
        case .persional:
            return "activity_terms_v2_privacy_optional_kwsk_item_title".Localizable()
        case .notification:
            return "activity_terms_v2_marketing_title".Localizable()
        case .privacy:
            return "activity_terms_privacyterms".Localizable()
        case .terms:
            return "activity_terms_probitterms".Localizable()
        case .thirdParty:
            return "third_party_licenses".Localizable()
        }
    }
}

struct TermSetting {
    var name: TermSettingType
    var hintTitle: TermSettingType
    var buttonTitle: TermSettingType
    var isSwitch: Bool
    var isEnableSwitch: Bool
    
    init(name: TermSettingType,
         hintitle: TermSettingType,
         buttonTitle: TermSettingType,
         isSwitch: Bool = false,
         isEnableSwitch: Bool = false) {
        self.name = name
        self.hintTitle = hintitle
        self.buttonTitle = buttonTitle
        self.isSwitch = isSwitch
        self.isEnableSwitch = isEnableSwitch
    }
    
    var params: [String: Any] {
        switch name {
        case .personalInfo:
            return ["marketing_privacy": isSwitch]
        case .email:
            return ["marketing_mail": isSwitch]
        case .sms:
            return ["marketing_sms": isSwitch]
        case .pushNoti:
            return ["marketing_push": isSwitch]
        case .nightTime:
            return ["nighttime_push": isSwitch]
        }
    }
}

enum TermSettingType: CaseIterable {
    case personalInfo
    case email
    case sms
    case pushNoti
    case nightTime
    
    var title: String {
        switch self {
        case .personalInfo:
            return "activity_terms_v2_privacy_optional_switch_title".Localizable()
        case .email:
            return "activity_terms_v2_email_marketing_switch_title".Localizable()
        case .sms:
            return "activity_terms_v2_sms_marketing_switch_title".Localizable()
        case .pushNoti:
            return "activity_terms_v2_push_marketing_switch_title".Localizable()
        case .nightTime:
            return "activity_terms_v2_nighttime_push_switch_title".Localizable()
        }
    }
    
    var hintTitle: String {
        switch self {
        case .personalInfo:
            return "activity_terms_v2_privacy_optional_switch_hint".Localizable()
        case .email:
            return "activity_terms_v2_email_marketing_switch_hint".Localizable()
        case .sms:
            return "activity_terms_v2_sms_marketing_switch_hint".Localizable()
        case .pushNoti:
            return "activity_terms_v2_push_marketing_switch_hint".Localizable()
        case .nightTime:
            return "activity_terms_v2_nighttime_push_switch_hint".Localizable()
        }
    }
    
    var buttonTitle: String {
        switch self {
        default:
            return "activity_terms_v2_privacy_optional_kwsk_item".Localizable()
        }
    }
    
    var url: String {
        switch self {
        case .personalInfo:
            return "https://static.probit.com/files/etc/privacyOptional.\(AppConstant.localeId.lowercased()).html"
        case .email:
            return "https://static.probit.com/files/etc/marketingMail.\(AppConstant.localeId.lowercased()).html"
        case .sms:
            return "https://static.probit.com/files/etc/marketingSms.\(AppConstant.localeId.lowercased()).html"
        case .pushNoti:
            return "https://static.probit.com/files/etc/marketingSms.\(AppConstant.localeId.lowercased()).html"
        case .nightTime:
            return "https://static.probit.com/files/etc/marketingSms.\(AppConstant.localeId.lowercased()).html"
        }
    }
    
    var susscessMsg: String {
        switch self {
        case .personalInfo:
            return "personalInfo"
        case .email:
            return "email"
        case .sms:
            return "sms"
        case .pushNoti:
            return "pushNoti"
        case .nightTime:
            return "nightTime"
        }
    }
    
    var errorMsg: String {
        switch self {
        default:
            let desc = "activity_terms_agreementdependency_not_satistied".Localizable()
            let termsTitle = "activity_terms_v2_privacy_optional_switch_title".Localizable()
            return String.init(format: desc, termsTitle)
        }
    }
}
