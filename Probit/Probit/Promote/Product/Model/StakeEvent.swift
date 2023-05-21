//
//  StakeEvenModel.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 22/09/2565 BE.
//

import Foundation
import UIKit

enum StakeEventType: Int, Codable {
    case UP_COMING = 1
    case RUNNING = 0
    case END = 2
    static func initValue(_ statDate: Date,_ enđate: Date) -> StakeEventType {
        let currentDate = Date().timeIntervalSince1970
        if currentDate > enđate.timeIntervalSince1970 {
            return .END
        } else if currentDate < statDate.timeIntervalSince1970 {
            return .UP_COMING
        } else {
            return .RUNNING
        }
    }
    
    var title: String {
        switch self {
        case .UP_COMING:
            return "stakeevent_tab_upcoming".Localizable()
        case .RUNNING:
            return "stakeevent_tab_running".Localizable()
        case .END:
            return "activity_event_endedbutton".Localizable()
        }
    }
    
    var colors: [UIColor] {
        switch self {
        case .UP_COMING:
            return [UIColor(hexString: "#FAA347")]
        case .RUNNING:
            return [UIColor(hexString: "#22D1A3"), UIColor.Basic.blue]
        case .END:
            return [UIColor(hexString: "#ADADAD")]
        }
    }
    
    func getTitle(startDate: Date?, endDate: Date?) -> String? {
        guard let startDate = startDate,
              let endDate = endDate else { return nil }
        switch self {
        case .UP_COMING:
            let delta = startDate.timeIntervalSince1970 - Date().timeIntervalSince1970
            return String(format: "timer_starts_in".Localizable(),
                          "\(delta.stringFromTimeInterval())")
        case .RUNNING:
            let delta = endDate.timeIntervalSince1970 - Date().timeIntervalSince1970
            return String(format: "timer_ends_in".Localizable(),
                          "\(delta.stringFromTimeInterval())")
        case .END:
            return "activity_event_endedbutton".Localizable()
        }
    }
}

enum StakeType: String, Codable {
    case USER = "user"
    case TRADE_MINING = "trademining"
    case AUTO = "auto"
    case STAKE_MINING = "stakemining"
    
    var colors: UIColor {
        switch self {
        case .USER, .AUTO:
            return UIColor(hexString: "#F25D4E")
        case .TRADE_MINING:
            return UIColor(hexString: "#75D7DE")
        case .STAKE_MINING:
            return UIColor(hexString: "#FAA347")
        }
    }
    
}

class StakeEventModel: Codable {
    var id: String?
    var currencyId: String?
    var step: Int?
    var startTime: Date?
    var endTime: Date?
    var active: Bool?
    var uiDescription: UIDescriptionModel?
    var rewardDesc: RewardDescModel?
    var stakeEventType: StakeEventType
    
    var hiddenDay: Bool {
        return startTime == nil || endTime == nil
    }
    
    init (entity: StakeEvent) {
        self.id = entity.id
        self.currencyId = entity.currencyId
        self.step = entity.step
        self.startTime = entity.startTime?.toDate()
        self.endTime = entity.endTime?.toDate()
        self.active = entity.active
        self.uiDescription = entity.uiDescription
        self.rewardDesc = entity.rewardDesc
        if let startTime = startTime, let endTime = endTime {
            self.stakeEventType = .initValue(startTime, endTime)
        } else {
            self.stakeEventType = .END
        }
    }
}



// MARK: - StakeAmount
struct StakeAmountModel: Codable {
    var stakeAmount: String?
    var stakeLockAmount: String?
    enum CodingKeys: String, CodingKey {
        case stakeAmount = "stake_amount"
        case stakeLockAmount = "stake_lock_amount"
    }
}

// MARK: - StakeCurrency

struct StakeDetailDataModel: Codable {
    var data: [StakeDetailModel]
    var count: String?
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case count = "count"
    }
}

struct StakeDetailModel: Codable {
    var id, type, status, amount: String?
    var idx: Int?
    var stakeTime, stakedTime: String?
    var stakeType: StakeType

    enum CodingKeys: String, CodingKey {
        case id, type, status, amount, idx
        case stakeTime = "stake_time"
        case stakedTime = "staked_time"
        case stakeType = "stake_type"
    }
}



struct StakeEvent: Codable {
    var id: String?
    var currencyId: String?
    var step: Int?
    var startTime: String?
    var endTime: String?
    var active: Bool?
    var uiDescription: UIDescriptionModel?
    var rewardDesc: RewardDescModel?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case currencyId = "currency_id"
        case step = "step"
        case startTime = "start_time"
        case endTime = "end_time"
        case active = "active"
        case uiDescription = "ui_description"
        case rewardDesc = "reward_desc"
    }
}

// MARK: - RewardDesc
struct RewardDescModel: Codable {
    var currencyId: String?
    var rules: [Rule]?

    enum CodingKeys: String, CodingKey {
        case currencyId = "currency_id"
        case rules = "rules"
    }
}

// MARK: - Rule
struct Rule: Codable {
    var cond: Cond?
    var staking: Staking?
    var reward: Reward?
    var minAmount: String?

    enum CodingKeys: String, CodingKey {
        case cond = "cond"
        case staking = "staking"
        case reward = "reward"
        case minAmount = "min_amount"
    }
}

// MARK: - Cond
struct Cond: Codable {
    var period: Int?

    enum CodingKeys: String, CodingKey {
        case period = "period"
    }
}

// MARK: - Reward
struct Reward: Codable {
    var annualRate: String?
    var paymentTime: PaymentTime?
    var minAmount: String?

    enum CodingKeys: String, CodingKey {
        case annualRate = "annualRate"
        case paymentTime = "paymentTime"
        case minAmount = "minAmount"
    }
}

enum PaymentTime: String, Codable {
    case daily = "daily"
    case end = "end"
    case manual = "manual"
}

// MARK: - Staking
struct Staking: Codable {
    var totalAmount: String?
    var capAmount: String?
    var minAmount: String?
    var capAmountPerUser: String?
    var stakingTotalAmount: String?
    var stakingCapAmount: String?
    var stakingCapAmountPerUser: String?

    enum CodingKeys: String, CodingKey {
        case totalAmount = "totalAmount"
        case capAmount = "capAmount"
        case minAmount = "minAmount"
        case capAmountPerUser = "capAmountPerUser"
        case stakingTotalAmount = "total_amount"
        case stakingCapAmount = "cap_amount"
        case stakingCapAmountPerUser = "cap_amount_per_user"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // totalAmount
        if let totalAmount = try? container.decode(String?.self, forKey: .totalAmount) {
            self.totalAmount = totalAmount
        } else {
            self.totalAmount = try? container.decode(Double?.self, forKey: .totalAmount)?.string
        }
        // capAmount
        if let capAmount = try? container.decode(String?.self, forKey: .capAmount) {
            self.capAmount = capAmount
        } else {
            self.capAmount = try? container.decode(Double?.self, forKey: .capAmount)?.string
        }
        // minAmount
        if let minAmount = try? container.decode(String?.self, forKey: .minAmount) {
            self.minAmount = minAmount
        } else {
            self.minAmount = try? container.decode(Double?.self, forKey: .minAmount)?.string
        }
        // capAmountPerUser
        if let capAmountPerUser = try? container.decode(String?.self, forKey: .capAmountPerUser) {
            self.capAmountPerUser = capAmountPerUser
        } else {
            self.capAmountPerUser = try? container.decode(Double?.self, forKey: .capAmountPerUser)?.string
        }
        // stakingTotalAmount
        if let stakingTotalAmount = try? container.decode(String?.self, forKey: .stakingTotalAmount) {
            self.stakingTotalAmount = stakingTotalAmount
        } else {
            self.stakingTotalAmount = try? container.decode(Double?.self, forKey: .stakingTotalAmount)?.string
        }
        // stakingCapAmount
        if let stakingCapAmount = try? container.decode(String?.self, forKey: .stakingCapAmount) {
            self.stakingCapAmount = stakingCapAmount
        } else {
            self.stakingCapAmount = try? container.decode(Double?.self, forKey: .stakingCapAmount)?.string
        }
        // stakingCapAmountPerUser
        if let stakingCapAmountPerUser = try? container.decode(String?.self, forKey: .stakingCapAmountPerUser) {
            self.stakingCapAmountPerUser = stakingCapAmountPerUser
        } else {
            self.stakingCapAmountPerUser = try? container.decode(Double?.self, forKey: .stakingCapAmountPerUser)?.string
        }
        //
//        do {
//            self.totalAmount = try container.decode(String.self, forKey: .totalAmount)
//        } catch DecodingError.typeMismatch {
//            self.totalAmount = "0"
//        }
//
//        do {
//            self.capAmount = try container.decode(String.self, forKey: .capAmount)
//        } catch DecodingError.typeMismatch {
//            self.capAmount = "0"
//        }
        
//        do {
//            self.minAmount = try container.decode(String.self, forKey: .minAmount)
//        } catch DecodingError.typeMismatch {
//            self.minAmount = "0"
//        }
        
//        do {
//            self.capAmountPerUser = try container.decode(String.self, forKey: .capAmountPerUser)
//        } catch DecodingError.typeMismatch {
//            self.capAmountPerUser = "0"
//        }
        
//        do {
//            self.stakingTotalAmount = try container.decode(String.self, forKey: .stakingTotalAmount)
//        } catch DecodingError.typeMismatch {
//            self.stakingTotalAmount = "0"
//        }
        
//        do {
//            self.stakingCapAmount = try container.decode(String.self, forKey: .stakingCapAmount)
//        } catch DecodingError.typeMismatch {
//            self.stakingCapAmount = "0"
//        }
        
//        do {
//            self.stakingCapAmountPerUser = try container.decode(String.self, forKey: .stakingCapAmountPerUser)
//        } catch DecodingError.typeMismatch {
//            self.stakingCapAmountPerUser = "0"
//        }
    }
}

// MARK: - UIDescription
struct UIDescriptionModel: Codable {
    var supportArticleId: String?
    var showGraphFrom: String?
    var logoImage: String?
    var locales: Locales?
    var startingAmount: String?
    var bgImage: String?
    var progressOverride: String?

    enum CodingKeys: String, CodingKey {
        case supportArticleId = "supportArticleId"
        case showGraphFrom = "showGraphFrom"
        case logoImage = "logoImage"
        case locales = "locales"
        case startingAmount = "startingAmount"
        case bgImage = "bgImage"
        case progressOverride = "progressOverride"
    }
}

// MARK: - Locales
struct Locales: Codable {
    var koKr: EnUs?
    var enUs: EnUs?
    var startingAmount: String?

    enum CodingKeys: String, CodingKey {
        case koKr = "ko-kr"
        case enUs = "en-us"
        case startingAmount = "startingAmount"
    }
}

// MARK: - EnUs
struct EnUs: Codable {
    var eventName: String?
    var prizeString: String?
    var period: String?
    let title: String?
    let name: String?
    let banner: String?
    let heroBg: String?
    let heroLogo: String?
    let landingName: String?
    let landingIcon: String?
    let landingTagline: String?

    enum CodingKeys: String, CodingKey {
        case eventName = "eventName"
        case prizeString = "prizeString"
        case period = "period"
        case title
        case name
        case banner
        case heroBg = "hero-bg"
        case heroLogo = "hero-logo"
        case landingName = "landing-name"
        case landingIcon = "landing-icon"
        case landingTagline = "landing-tagline"
    }
}

struct DepositAddress: Codable {
    var platformID, address: String?
    var destinationTag: String?

    enum CodingKeys: String, CodingKey {
        case platformID = "platform_id"
        case address
        case destinationTag = "destination_tag"
    }
}
