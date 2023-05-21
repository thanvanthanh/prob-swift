
import Foundation

class StakeAmount: Codable {
    var stakeAmount: String?
    var stakeLockAmount: String?
    enum CodingKeys: String, CodingKey {
        case stakeAmount = "stake_amount"
        case stakeLockAmount = "stake_lock_amount"
    }
}
