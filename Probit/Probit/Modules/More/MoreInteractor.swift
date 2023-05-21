//
//  MoreInteractor.swift
//  Probit
//
//  Created by Nguyen Quang on 21/09/2022.
//  
//

import Foundation
import UIKit

class MoreInteractor: PresenterToInteractorMoreProtocol {
    // MARK: Properties
    var mores: [MoreItem] = MoreItem.allCases
    var presenter: InteractorToPresenterMoreProtocol?
}

enum MoreItem: CaseIterable {
    case buyCrypto
    case exclusive
    case ieo
    case purchasePROB
    case tradingCompetition
    case airdrops
    case stake
    case autoHold
    case referralProgram
    case announcements
    case FAQ
    case contactUs
    
    var title: String {
        switch self {
        case .buyCrypto:
            return "v2icon_home_buycrypto".Localizable()
        case .exclusive:
            return "v2icon_home_exclusive".Localizable()
        case .ieo:
            return "v2icon_home_ieo".Localizable()
        case .purchasePROB:
            return "v2icon_home_purchase".Localizable()
        case .tradingCompetition:
            return "v2icon_home_tc".Localizable()
        case .airdrops:
            return "v2icon_home_airdrops".Localizable()
        case .stake:
            return "v2icon_home_stake".Localizable()
        case .autoHold:
            return "v2icon_home_autohold".Localizable()
        case .referralProgram:
            return "v2icon_home_referral".Localizable()
        case .announcements:
            return "notificationcenter_tab_announcements".Localizable()
        case .FAQ:
            return "v2icon_home_faq".Localizable()
        case .contactUs:
            return "fragment_settings_support".Localizable()
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .buyCrypto:
            return UIImage(named: "ico_more_buycrypto")
        case .exclusive:
            return UIImage(named: "ico_more_exclusive")
        case .ieo:
            return UIImage(named: "ico_more_ieo")
        case .purchasePROB:
            return UIImage(named: "ico_more_purchase")
        case .tradingCompetition:
            return UIImage(named: "ico_more_trading_competition")
        case .airdrops:
            return UIImage(named: "ico_more_airdrops")
        case .stake:
            return UIImage(named: "ico_more_stake")
        case .autoHold:
            return UIImage(named: "ico_more_auto_hold")
        case .referralProgram:
            return UIImage(named: "ico_more_referral_program")
        case .announcements:
            return UIImage(named: "ico_more_announcements")
        case .FAQ:
            return UIImage(named: "ico_more_FAQ")
        case .contactUs:
            return UIImage(named: "ico_more_contact")
        }
    }
    
    var urlString: String {
        switch self {
        case .buyCrypto:
            return ""
        case .exclusive:
            return AppConstant.Link.exclusive
        case .ieo:
            return AppConstant.Link.ieo
        case .purchasePROB:
            return ""
        case .tradingCompetition:
            return ""
        case .airdrops:
            return AppConstant.Link.airdrops
        case .stake:
            return ""
        case .autoHold:
            return AppConstant.Link.autoHold
        case .referralProgram:
            return ""
        case .announcements:
            return AppConstant.Link.announcements
        case .FAQ:
            return AppConstant.Link.faq
        case .contactUs:
            return AppConstant.Link.contactUs
        }
    }
}
