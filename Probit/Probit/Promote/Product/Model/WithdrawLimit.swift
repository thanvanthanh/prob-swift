
import Foundation

struct WithdrawLimit: Codable {
    var currency: String?
    var quota: String?
    var usage: String?
    var available: String?

    enum CodingKeys: String, CodingKey {
        case currency = "currency"
        case quota = "quota"
        case usage = "usage"
        case available = "available"
    }
}
