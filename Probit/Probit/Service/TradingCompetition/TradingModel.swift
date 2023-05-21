//
//  TradingCompetition.swift
//  Probit
//
//  Created by Nguyen Quang on 23/09/2022.
//

import Foundation

// MARK: Trading Response
struct TradingResponse: Codable {
    let data: [Trading]
}

struct Trading: Codable {
    let id: String
    let startTime: String
    let endTime: String
    let marketIds: [String]
    let eventNameEn: String
    let prizeTotalEn: String
    let logoImage: String
    let hideDate: Bool
    let boost: TradingBoost?
    
    var isActiveBoost: Bool {
        guard let boost = boost, boost.active else { return false }
        return true
    }
    
    var startDate: Date? { startTime.toDate() }
    var endDate: Date? { endTime.toDate() }
    
    var stakeEventType: StakeEventType? {
        guard let startDate = startDate,
              let endDate = endDate else { return nil }
        return .initValue(startDate, endDate)
    }
    
    var titleTrading: String? {
        guard let startDate = startDate,
              let endDate = endDate else { return nil }
        return stakeEventType?.getTitle(startDate: startDate,
                                        endDate: endDate)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case startTime = "start_time"
        case endTime = "end_time"
        case marketIds = "market_ids"
        case eventNameEn = "event_name_en"
        case prizeTotalEn = "prize_total_en"
        case logoImage = "logo_image"
        case hideDate
        case boost
    }
}

struct TradingBoost: Codable {
    let active: Bool
    let mode: String?
    let targetVolume: String?
    let targetCurrency: String?
    let targetAmount: String?

    enum CodingKeys: String, CodingKey {
        case active
        case mode
        case targetVolume = "target_volume"
        case targetCurrency = "target_currency"
        case targetAmount = "target_amount"
    }
}

// MARK: Trading Detail
struct TradingDetailResponse: Codable {
    let data: TradingDetail
}

struct TradingDetail: Codable {
    let id: String
    let startTime: String
    let endTime: String
    let marketIds: [String]
    let config: TradingConfig
    let uiDescription: TradingUIDescription
    
    var avatar: String { uiDescription.data.logoImage }
    var minStakeCount: String? { config.minStakeCount }
    var name: String? { uiDescription.data.localesContent?.name }
    
    var description: String? { uiDescription.data.localesContent?.desc }
    var prizeTotal: String? { uiDescription.data.localesContent?.prizeTotal }
    var prizeList: [TradingPrizeList] { uiDescription.data.localesContent?.prizeList ?? [] }
    var boostedPrizeList: [TradingPrizeList] { uiDescription.data.localesContent?.boostedPrizeList ?? [] }
    var notice: [String] { uiDescription.data.localesContent?.notice ?? [] }

    
    var startDate: Date? { startTime.toDate() }
    var endDate: Date? { endTime.toDate() }
    
    enum CodingKeys: String, CodingKey {
        case id
        case startTime = "start_time"
        case endTime = "end_time"
        case marketIds = "market_ids"
        case config
        case uiDescription = "ui_description"
    }
}

struct TradingConfig: Codable {
    let showTop: String?
    let minStakeCount: String?
    let kycLevel: String?
    let rankingUseQuote: Bool?
    let rankingCurrency: String?
    
    var isShowStake: Bool {
        guard let minStakeCount = minStakeCount, minStakeCount.asInt > 0 else { return false }
        return true
    }
    
    var isShowKyc: Bool {
        guard let kycLevel = kycLevel, kycLevel.asInt > 0 else { return false }
        return true
    }
    
    enum CodingKeys: String, CodingKey {
        case showTop = "show_top_n"
        case minStakeCount = "min_stake_count"
        case kycLevel = "kyc_level"
        case rankingUseQuote = "ranking_use_quote"
        case rankingCurrency = "ranking_currency"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let showTop = try? container.decode(String.self, forKey: .showTop) {
            self.showTop = showTop
        } else {
            self.showTop = try? container.decode(Int.self, forKey: .showTop).string
        }
        if let minStakeCount = try? container.decode(String.self, forKey: .minStakeCount) {
            self.minStakeCount = minStakeCount
        } else {
            self.minStakeCount = try? container.decode(Int.self, forKey: .minStakeCount).string
        }
        if let kycLevel = try? container.decode(String.self, forKey: .kycLevel) {
            self.kycLevel = kycLevel
        } else {
            self.kycLevel = try? container.decode(Int.self, forKey: .kycLevel).string
        }
        self.rankingUseQuote = try? container.decode(Bool.self, forKey: .rankingUseQuote)
        self.rankingCurrency = try? container.decode(String.self, forKey: .rankingCurrency)
    }
}

struct TradingUIDescription: Codable {
    let data: TradingUIDescriptionData
}

struct TradingUIDescriptionData: Codable {
    let logoImage: String
    let locales: [String: TradingLocalesInfo]
    let boost: TradingBoost?
    let notice: Bool
    let targetMarket: [String]?
    var localesContent: TradingLocalesInfo? { locales[AppConstant.locale] }
}

struct TradingLocalesInfo: Codable {
    let name: String
    let desc: String
    let prizeTotal: String
    let prizeList: [TradingPrizeList]
    let boostedPrizeList: [TradingPrizeList]?
    let notice: [String]?
}

struct TradingPrizeList: Codable {
    let rank: String?
    let amount: String
    
    var rankNumber: String {
        switch rank {
        case "1":
            return "1 st"
        case "2":
            return "2nd"
        case "3":
            return "3rd"
        default:
            return "\(rank ?? "4")th"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let rank = try? container.decode(String.self, forKey: .rank) {
            self.rank = rank
        } else {
            self.rank = try? container.decode(Int.self, forKey: .rank).string
        }
        amount = (try? container.decode(String.self, forKey: .amount)).value
    }
}

// MARK: -  Leaderboard
struct TradingLeaderboard: Codable {
    let updatedTime: String
    let data: [LeaderboardData]
    let isIneligible: Bool?
    
    var updatedTimeInGMT: String {
        guard let time = updatedTime.toDate("yyyy-MM-dd'T'HH:mm:ss.SSSZ")?.stringFromDateWithSemantic() else {
            return ""
        }
        return time
    }
    
    enum CodingKeys: String, CodingKey {
        case updatedTime = "updated_time"
        case data
        case isIneligible = "is_ineligible"
    }
}

struct LeaderboardData: Codable {
    let rank: Int
    let email: String
    let trades: Int?
    let volume: Double?
}

struct StakeUserData: Codable {
    let data: StakeUser?
}

struct StakeUser: Codable {
    let prob: String?
    
    enum CodingKeys: String, CodingKey {
        case prob = "PROB"
    }
}
