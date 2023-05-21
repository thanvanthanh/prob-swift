//
//  UITabbar_Ext.swift
//  Earable
//
//  Created by Nguyen Quoc Tung on 9/8/20.
//  Copyright © 2020 Earable. All rights reserved.
//

import UIKit

let defaultTabbarHeight: CGFloat = 60.0

enum TabBarItem {
    case home
    case exchange
    case history
    case wallet
    case settings
    
    var selectedImage: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "ico_home_active")
        case .exchange:
            return UIImage(named: "ico_exchange_active")
        case .history:
            return UIImage(named: "ico_history_active")
        case .wallet:
            return UIImage(named: "ico_wallet_active")
        case .settings:
            return UIImage(named: "ico_setting_active")
        }
    }
    
    var unselectedImage: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "ico_home")
        case .exchange:
            return UIImage(named: "ico_exchange")
        case .history:
            return UIImage(named: "ico_history")
        case .wallet:
            return UIImage(named: "ico_wallet")
        case .settings:
            return UIImage(named: "ico_setting")
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "navigationbar_home".Localizable()
        case .exchange:
            return "navigationbar_market".Localizable()
        case .history:
            return "navigationbar_history".Localizable()
        case .wallet:
            return "navigationbar_wallet".Localizable()
        case .settings:
            return "navigationbar_settings".Localizable()
        }
    }
    
    var rawIndex: Int {
        switch self {
        case .home:
            return 0
        case .exchange:
            return 1
        case .history:
            return 2
        case .wallet:
            return 3
        case .settings:
            return 4
        }
    }
}
