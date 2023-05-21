//
//  SettingModel.swift
//  Probit
//
//  Created by Thân Văn Thanh on 29/09/2022.
//

import Foundation

// MARK: Membership
struct MembershipModel: Codable {
    let data: MembershipDetailModel
}

struct MembershipDetailModel: Codable {
    let probAmount: String
    let tradeFeeRate: String
    let tradeFeeRateByProb: String
    let referralBonusAmount: String
    let membership: String
    let tradeMiningReward: String
    let actualFeeWithTradeMining: String
    let tradeMining: String
    let version: String
    let nextLevel: String
    let referralDiscount: Bool
    let referralDiscountAmount: String
    let stakeAmount: String
    var membershipType: MembershipType? {
            MembershipType(rawValue: membership)
        }
    var membershipNextLevel: MembershipType? {
        guard let index =  MembershipType.allCases.firstIndex(where: { $0 == membershipType }),
              index < MembershipType.allCases.count - 1 else { return MembershipType.allCases.last }
        return MembershipType.allCases[index + 1]
    }

    enum CodingKeys: String, CodingKey {
        case probAmount = "prob_amount"
        case tradeFeeRate = "trade_fee_rate"
        case tradeFeeRateByProb = "trade_fee_rate_by_prob"
        case referralBonusAmount = "referral_bonus_amount"
        case membership
        case tradeMiningReward = "trade_mining_reward"
        case actualFeeWithTradeMining = "actual_fee_with_trade_mining"
        case tradeMining = "trade_mining"
        case version
        case nextLevel = "next_level"
        case referralDiscount = "referral_discount"
        case referralDiscountAmount = "referral_discount_amount"
        case stakeAmount = "stake_amount"
    }
    
    enum MembershipType: String, CaseIterable {
        case standard
        case vip1, vip2, vip3, vip4, vip5, vip6, vip7, vip8, vip9, vip10, vip11
        
        var icon: String {
            switch self {
            case .standard:
                return "ico_star"
            default :
                return "ico_diamond"
            }
        }
        
        var title: String? {
            switch self {
            case .standard:
                return "membershiplevel_standard".Localizable()
            case .vip1:
                return "membershiplevel_vip1".Localizable()
            case .vip2:
                return "membershiplevel_vip2".Localizable()
            case .vip3:
                return "membershiplevel_vip3".Localizable()
            case .vip4:
                return "membershiplevel_vip4".Localizable()
            case .vip5:
                return "membershiplevel_vip5".Localizable()
            case .vip6:
                return "membershiplevel_vip6".Localizable()
            case .vip7:
                return "membershiplevel_vip7".Localizable()
            case .vip8:
                return "membershiplevel_vip8".Localizable()
            case .vip9:
                return "membershiplevel_vip9".Localizable()
            case .vip10:
                return "membershiplevel_vip10".Localizable()
            case .vip11:
                return "membershiplevel_vip11".Localizable()
            }
        }
        var levelNumber: Int {
            switch self {
            case .standard:
                return 0
            case .vip1:
                return 1
            case .vip2:
                return 2
            case .vip3:
                return 3
            case .vip4:
                return 4
            case .vip5:
                return 5
            case .vip6:
                return 6
            case .vip7:
                return 7
            case .vip8:
                return 8
            case .vip9:
                return 9
            case .vip10:
                return 10
            case .vip11:
                return 11
            }
        }
    }
}

// MARK: Pay in Prob
struct GetPayInProbModel: Codable {
    let payInProb: String
    
    enum CodingKeys: String, CodingKey {
        case payInProb = "pay_in_prob"
    }
}

struct PostPayInProbModel: Codable {
    let result: String
}

// MARK: Referrer Count
struct ReferrerCountModel: Codable {
    let data: ReferrerCountDetailModel
}

struct ReferrerCountDetailModel: Codable {
    let count: String?
}

// MARK: - ReferralCode
struct ReferralCodeModel: Codable {
    let data: ReferralCodeDetailModel
}

struct ReferralCodeDetailModel: Codable {
    let id: String
    let referrerNo: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case referrerNo = "referrer_no"
    }
}

// MARK: - ReferrerEarned
struct ReferrerEarned: Codable {
    let data: [String: Double]
    
    var model: [ReferrerEarnedModel] {
        var response: [ReferrerEarnedModel] = [ReferrerEarnedModel(name: "PROB", value: data["PROB"] ?? 0)]
        let newData = data.compactMap { $0.key == "PROB" ? nil : ReferrerEarnedModel(name: $0.key, value: $0.value) }
        response.append(contentsOf: newData)
        return response
    }
    
}

class ReferrerEarnedModel {
    let name: String
    let value: Double
    
    init(name: String, value: Double) {
        self.name = name
        self.value = value
    }
}
 
// MARK: - Check Step

struct CheckStepModel: Codable {
    let data: Int?
}

// MARK: - User KYC Status

struct UserKycStatusModel: Codable {
    let data: UserKycStatusDetailModel
}

struct UserKycStatusDetailModel: Codable {
    let status: String
    let rejectMessage: String?
    let rejectCode: [String]?
    let availableTime: String?
    let page: String?
    
    //check
    var statusType: StatusType? {
        StatusType(rawValue: status)
    }
    var pageType: PageType? {
        PageType(rawValue: page.value)
    }
    
    var availableTimeDate: Date? {
        self.availableTime?.toDate()
    }
    
    var rejectCodeArray: [String] {
        guard let rejectCode = rejectCode else { return [] }
        return rejectCode.map { RejectCodeType(rawValue: $0)?.message ?? "" }
    }
    
    enum CodingKeys: String, CodingKey {
        case status
        case rejectMessage = "reject_message"
        case availableTime = "available_time"
        case rejectCode = "reject_code"
        case page
    }
    
    enum StatusType: String, CaseIterable {
        case new
        case begin
        case pending
        case done
        case rejected
    }
    
    enum RejectCodeType: String, CaseIterable {
        case identityFverificationFail = "identity_verification_fail"
        case others
        case tooManyRetry = "too_many_retry"
        case idInfoDataMismatch = "id_info_data_mismatch"
        case idImageBadImage = "id_image_bad_image"
        case idImageError = "id_image_error"
        case idImageInvalidId = "id_image_invalid_id"
        case idImageInvalidImage = "id_image_invalid_image"
        case livenessFail = "liveness_fail"
        case faceCompareFail = "face_compare_fail"
        case faceImageSelfieMismatch = "face_image_selfie_mismatch"
        case multipleFaces = "multiple_faces"
        case noFace = "no_face"
        case noCode = "no_code"
        
        var message: String {
            switch self {
            case .identityFverificationFail:
                return "globalkyc_rejectmsg_identity_verification_fail".Localizable()
            case .others:
                return "globalkyc_rejectmsg_others".Localizable()
            case .tooManyRetry:
                return "globalkyc_rejectmsg_too_many_retry".Localizable()
            case .idInfoDataMismatch:
                return "globalkyc_rejectmsg_id_info_data_mismatch".Localizable()
            case .idImageBadImage:
                return "globalkyc_rejectmsg_id_image_bad_image".Localizable()
            case .idImageError:
                return "globalkyc_rejectmsg_id_image_error".Localizable()
            case .idImageInvalidId:
                return "globalkyc_rejectmsg_id_image_invalid_id".Localizable()
            case .idImageInvalidImage:
                return "globalkyc_rejectmsg_id_image_invalid_image".Localizable()
            case .livenessFail:
                return "globalkyc_rejectmsg_liveness_fail".Localizable()
            case .faceCompareFail:
                return "globalkyc_rejectmsg_face_compare_fail".Localizable()
            case .faceImageSelfieMismatch:
                return "globalkyc_rejectmsg_face_image_selfie_mismatch".Localizable()
            case .multipleFaces:
                return "globalkyc_rejectmsg_multiple_faces".Localizable()
            case .noFace:
                return "globalkyc_rejectmsg_no_face".Localizable()
            case .noCode:
                return "Unable to verify the cause of rejection. Please check the related email for further details and contact customer support for additional assistance."
            }
        }
    }
    
    enum PageType: String, CaseIterable {
        case country = "country"
        case personalInfo = "personal_info"
        case selfieImage = "selfie_image"
        case idType = "id_type"
        case idImage = "id_image"
        case loading = "loading"
        case checkData = "check_data"
        case ocrConfirm = "ocr_confirm"
        
        var progressValue: Float {
            let total: Float = 8.0
            switch self {
            case .country:
                return 1.0/total
            case .personalInfo:
                return 2.0/total
            case .selfieImage:
                return 3.0/total
            case .idType:
                return 4.0/total
            case .idImage:
                return 5.0/total
            case .loading:
                return 6.0/total
            case .ocrConfirm:
                return 7.0/total
            case .checkData:
                return 8.0/total
            }
        }
    }
}

struct GetListKycCountriesResponseModel: Decodable {
    let data: [String]
}

// MARK: - Runtime Config

struct RuntimeConfig: Codable {
    let appForceUpdateVersion: Int
    let appUnderMaintenance: Bool
    let appMaintenanceNoticeUrl: String
    let appMaintenanceNoticeFrom, appMaintenanceNoticeUntil: Int
    let appMaintenanceNoticeDisplayName: [String: String]
}
