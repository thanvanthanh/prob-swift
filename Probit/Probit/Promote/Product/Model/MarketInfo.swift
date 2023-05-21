
import Foundation


// MARK: - Datum
struct MarketInfo: Codable {
    let id: String
    let tc: String?
    let warning: KycStep
    let warningLink: String?
    let trademining: Bool?
    let vip, kycStep: KycStep
    let bannedCountries: [String]?
    let serviceType: ServiceType

    enum CodingKeys: String, CodingKey {
        case id, tc, warning
        case warningLink = "warning_link"
        case trademining, vip
        case kycStep = "kyc_step"
        case bannedCountries = "banned_countries"
        case serviceType = "service_type"
    }
}

enum KycStep: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(KycStep.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for KycStep"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
    
    var number: Int {
        switch self {
        case .integer(let number):
            return number
        case .string(let numberString):
            return Int(numberString) ?? -1
        }
    }
    
}

enum ServiceType: String, Codable {
    case all = "all"
    case korea = "korea"
    case global = "global"
}

extension Array where Element == MarketInfo {
    func global() -> Self {
        let filterItems = self.filter { $0.serviceType == .all || $0.serviceType == .global }
        return filterItems
    }
}
