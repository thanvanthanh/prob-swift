//
//  TermsEntity.swift
//  Probit
//
//  Created by Nguyen Quang on 22/08/2022.
//

import Foundation

import Foundation

class TermsEntity: InteractorToEntityTermsProtocol {

    func notificationPreference(marketingPrivacy: Bool,
                                marketingMail: Bool,
                                marketingPush: Bool,
                                marketingSms: Bool,
                                nighttimePush: Bool,
                                completionHandler: @escaping (Result<NotificationPreferenceResponse, ServiceError>) -> Void) {
        HomeAPI().notificationPreference(marketingPrivacy: marketingPrivacy,
                                         marketingMail: marketingMail,
                                         marketingPush: marketingPush,
                                         marketingSms: marketingSms,
                                         nighttimePush: nighttimePush) { result in
            completionHandler(result)
        }
    }
}


struct Terms {
    var isSelected: Bool
    var name: TermsType
    var subContent: [Terms]
    var isMandatory: Bool { subContent.count == 0 }

    init(name: TermsType,
         isSelected: Bool = false,
         subContent: [Terms] = []) {
        self.name = name
        self.subContent = subContent
        self.isSelected = isSelected
    }
}

enum TermsType: CaseIterable {
    case all
    case termOfService
    case privacyPolicy
    
    case agreeMarketingPrivacy
    case agreeeMarketingEmail
    case agreeeMarketingSMS
    case agreeeMarketingPush
    case agreeeNighttimePush
    
    var title: String {
        switch self {
        case .all:
            return "activity_agreement_agreeall_text".Localizable()
        case .termOfService:
            return "activity_terms_v2_term_of_service".Localizable()
        case .privacyPolicy:
            return "activity_terms_v2_privacy_policy".Localizable()
        case .agreeMarketingPrivacy:
            return "activity_terms_v2_privacy_optional_kwsk_item_title".Localizable()
            
        case .agreeeMarketingEmail:
            return "activity_terms_push_email".Localizable()
        case .agreeeMarketingSMS:
            return "activity_terms_v2_SMS_text".Localizable()
        case .agreeeMarketingPush:
            return "activity_terms_push_message".Localizable()
        case .agreeeNighttimePush:
            return "activity_terms_push_message".Localizable()
        }
    }
    
    var url: String {
        switch self {
        case .all: return ""
        case .termOfService:
            return "https://static.probit.com/files/etc/tos.\(AppConstant.localeId.lowercased()).global.html"
        case .privacyPolicy:
            return "https://static.probit.com/files/etc/privacy.\(AppConstant.localeId.lowercased()).global.html"
        case .agreeMarketingPrivacy:
            return "https://static.probit.com/files/etc/privacyOptional.\(AppConstant.localeId.lowercased()).html"
        case .agreeeMarketingEmail:
            return "https://static.probit.com/files/etc/marketingMail.\(AppConstant.localeId.lowercased()).html"
        case .agreeeMarketingSMS:
            return "https://static.probit.com/files/etc/marketingSms.\(AppConstant.localeId.lowercased()).html"
        case .agreeeMarketingPush:
            return "https://static.probit.com/files/etc/marketingPush.\(AppConstant.localeId.lowercased()).html"
        case .agreeeNighttimePush:
            return "https://static.probit.com/files/etc/marketingSms.\(AppConstant.localeId.lowercased()).html"
        }
    }
}
