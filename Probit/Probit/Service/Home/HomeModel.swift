//
//  HomeModel.swift
//  Probit
//
//  Created by Nguyen Quang on 12/09/2022.
//

import Foundation

// MARK: - HomeConfig
struct HomeConfig: Codable {
    let global: [HomeConfigGlobal]
}

struct HomeConfigGlobal: Codable {
    let type: String
    let content: [String]?
}

// MARK: - Home Banner sectiom
struct BannerResponse: Codable {
    let data: [BannerData]
    let count: String
}

struct BannerData: Codable {
    let id: String
    let eventLink: String?
    let locale: [String: LocationContent]
    
    var localeTitle: String? { locale[AppConstant.locale]?.title }
    var localeBannerUrl: String? { locale[AppConstant.locale]?.imgURL }
    
    enum CodingKeys: String, CodingKey {
        case id
        case locale
        case eventLink = "event_link"
    }
}

struct LocationContent: Codable {
    let imgURL: String?
    let landingImgURL: String?
    let link: String?
    let title: String?
    let eventBannerImage: String?

    enum CodingKeys: String, CodingKey {
        case imgURL = "imgUrl"
        case landingImgURL = "landingImgUrl"
        case link, title
        case eventBannerImage = "event_banner_image"
    }
}

// MARK: - Profile
struct ProfileInfo: Codable {
    let id: String
    let email: String
    let language: String?
    let uid: String
    var marketingPrivacy: Bool?
    var subscriptions: NotificationPreferenceData?
    var transfer: Transfer?
    var suspend: Suspend?

    var isShowTermScreen: Bool {
        let marketingMail: Bool? = subscriptions?.marketingMail
        let marketingPush: Bool? = subscriptions?.marketingPush
        let marketingSms: Bool? = subscriptions?.marketingSms
        let nighttimePush: Bool? = subscriptions?.nighttimePush
        if marketingMail != nil && marketingPush != nil && marketingSms != nil && nighttimePush != nil {
            return false
        }
        return true
    }

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case language
        case uid
        case marketingPrivacy = "marketing_privacy"
        case subscriptions
        case transfer
        case suspend
    }
}

struct NotificationPreferenceData: Codable {
    var marketingPrivacy: Bool?
    var marketingMail: Bool?
    var marketingPush: Bool?
    var marketingSms: Bool?
    var nighttimePush: Bool?
    
    enum CodingKeys: String, CodingKey {
        case marketingPrivacy = "marketing_privacy"
        case marketingMail = "marketing_mail"
        case marketingPush = "marketing_push"
        case marketingSms = "marketing_sms"
        case nighttimePush = "nighttime_push"
    }
}

struct Transfer: Codable {
    var allow_deposit: Bool?
    var allow_withdrawal: Bool?
    
    enum CodingKeys: String, CodingKey {
        case allow_deposit
        case allow_withdrawal
    }
}

struct Suspend: Codable {
    var withdrawal: WithdrawalSuspend?
    
    enum CodingKeys: String, CodingKey {
        case withdrawal
    }
}

struct WithdrawalSuspend: Codable {
    
    var time: String?
    var reason: String?
    var period: Int?
    var date: Date? {
        time?.toDate("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", timeZone: TimeZone(secondsFromGMT: 0))
    }
    
    enum CodingKeys: String, CodingKey {
        case time, reason,period
    }
}

struct NotificationPreferenceResponse: Codable {
    let data: NotificationPreferenceData
}

// MARK: - NEW COIN
struct NewCoinsResponse: Codable {
    let coinInfo: [String: CoinInfo?]
    let newListings: [String]
    
    enum CodingKeys: String, CodingKey {
        case coinInfo = "coin_info"
        case newListings = "new_listings"
    }
}

struct CoinInfo: Codable {
    let listingArticleId: String?
    let logourl: String?
    let displayName: LocalizableModel?
    
    enum CodingKeys: String, CodingKey {
        case listingArticleId = "listing_article_id"
        case logourl = "logo_url"
        case displayName = "display_name"
    }
}

// MARK: - Annoucement
struct AnnoucementResponse: Codable {
    let data: [Annoucement]
}

struct Annoucement: Codable {
    let articleId: Int?
    let title: String?
    let sectionId: String?
    let updateDate: String?
    let isPinned: Bool?
    let isMachineTranslated: Bool?
    
    enum CodingKeys: String, CodingKey {
        case articleId = "article_id"
        case title
        case sectionId = "section_id"
        case updateDate = "update_date"
        case isPinned = "is_pinned"
        case isMachineTranslated = "is_machine_translated"
    }
}

// MARK: - Exclusive
struct ExclusiveResponse: Codable {
    let data: [Exclusive]
}

struct Exclusive: Codable {
    let id: String
    let currencyId: String?
    let buyCurrencyId: String?
    let discountRate: String?
    let startTime: String?
    let endTime: String?
    let uiDescription: ExclusiveUIDescription
    
    var eventType: StakeEventType? {
        guard let startDate = startTime?.toDate(),
              let endDate = endTime?.toDate() else { return nil }
        return .initValue(startDate, endDate)
    }
    var rate: String {
        guard let bonusRate = discountRate?.doubleValue() else {
            return "-%"
        }
        return Int(bonusRate * 100).string + "%"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case currencyId = "currency_id"
        case buyCurrencyId = "buy_currency_id"
        case discountRate = "discount_rate"
        case startTime = "start_time"
        case endTime = "end_time"
        case uiDescription = "ui_description"
    }
}

struct ExclusiveUIDescription: Codable {
    let articleId: String
    let locales: [String: LocationContent]
    
    var localeTitle: String? { locales[AppConstant.locale]?.title }
    var localeBannerUrl: String? { locales[AppConstant.locale]?.eventBannerImage }
    
    enum CodingKeys: String, CodingKey {
        case articleId = "article_id"
        case locales
    }
}

// MARK: - IEO
struct IEOResponse: Codable {
    let data: [String: IEOModel]
}

struct IEOModel: Codable {
    let im: ImModel?
    let uiData: IeoUiDataModel?
    var imPhases: [ImPhasesModel] { im?.phases ?? [] }
    var uiPhases: [UIDataPhasesModel] { uiData?.phases ?? [] }
    
    enum CodingKeys: String, CodingKey {
        case im
        case uiData = "ui_data"
    }
}

struct ImModel: Codable {
    let phases: [ImPhasesModel]
}

struct IeoUiDataModel: Codable {
    let phases: [UIDataPhasesModel]
}

struct ImPhasesModel: Codable {
    let price: String?
    let totalQty: String?
    let orderMinQty: String?
    let startTime: String?
    let endTime: String?
    let quoteOpts: [String: QuoteOptsBonusRate]
    
    var rate: String {
        guard let bonusRate = quoteOpts["PROB"]?.bonusRate.doubleValue() else {
            return "-%"
        }
        return Int(bonusRate * 100).string + "%"
    }
    var startDate: Date? { startTime?.toDate("yyyy-MM-dd'T'HH:mm:ssZ") }
    var endDate: Date? { endTime?.toDate("yyyy-MM-dd'T'HH:mm:ssZ") }
    
    var eventType: StakeEventType? {
        guard let startDate = startDate,
              let endDate = endDate else { return .END }
        return .initValue(startDate, endDate)
    }
    
    enum CodingKeys: String, CodingKey {
        case price
        case totalQty = "total_qty"
        case orderMinQty = "order_min_qty"
        case startTime = "start_time"
        case endTime = "end_time"
        case quoteOpts = "quote_opts"
    }
}

struct UIDataPhasesModel: Codable {
    let enUs: EnUs?
    let ver: String?
    
    enum CodingKeys: String, CodingKey {
        case enUs = "en-us"
        case ver = "ver"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let ver = try? container.decode(String.self, forKey: .ver) {
            self.ver = ver
        } else {
            self.ver = try? container.decode(Int.self, forKey: .ver).string
        }
        self.enUs = try? container.decode(EnUs?.self, forKey: .enUs)
    }
}

struct QuoteOptsBonusRate: Codable {
    let bonusRate: String
    
    enum CodingKeys: String, CodingKey {
        case bonusRate = "bonus_rate"
    }
}

struct MarketResponse: Codable {
    let data: [Market]
}

struct ConfigWdwarnModel: Codable {
    var withdrawal: [ConfigWithdrawal]?
    var deposit: [ConfigDeposit]?
    var dictionary: [String: String]?
}

// MARK: - Deposit
struct ConfigDeposit: Codable {
    var currencyID: String?
    var platformID: String?
    var notice: [DepositNotice]?

    enum CodingKeys: String, CodingKey {
        case currencyID = "currency_id"
        case platformID = "platform_id"
        case notice
    }
}
// MARK: - DepositNotice
struct DepositNotice: Codable {
    var type: NoticeType?
    var text: PurpleText?
    var articleID, data: String?

    enum CodingKeys: String, CodingKey {
        case type, text
        case articleID = "article_id"
        case data
    }
}

// MARK: - PurpleText
struct PurpleText: Codable {
    var predefined: String?
    var value: [String]?
}

// TypeEnum.swift
enum NoticeType: String, Codable {
    case POPUP = "popup"
    case SMART_CONTRACT = "smart_contract"
    case TEXT = "text"
}

// MARK: - Withdrawal
struct ConfigWithdrawal: Codable {
    var currencyID: String?
    var platformID: String?
    var notice: [WithdrawalNotice]?

    enum CodingKeys: String, CodingKey {
        case currencyID = "currency_id"
        case platformID = "platform_id"
        case notice
    }
}
// MARK: - WithdrawalNotice
struct WithdrawalNotice: Codable {
    var type: NoticeType?
    var text: PurpleText?
    var data: String?
}


struct PrimaryphoneResponse: Codable {
    var ok: Bool?
    var result: PrimaryphoneModel?
}

struct PrimaryphoneModel: Codable {
    var hash: String?
    var country: String?
    var countryCallingCode: String?
    var maskedNo: String?
    var maskedIntlNoFormatted: String?
    var maskedNationalNoFormatted: String?
    var nationalNoFormatted: String?
}
