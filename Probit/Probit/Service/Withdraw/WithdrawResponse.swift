
import Foundation

struct WidthdrawResponse: Codable {
    var data: WithdrawInformation?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decodeIfPresent(WithdrawInformation.self, forKey: .data)
    }
}

struct WithdrawInformation: Codable {
    var address: String?
    var amount: String?
    var confirmations: Int?
    var currency_id: String?
    var destination_tag: String?
    var fee: String?
    var fee_currency_id: String?
    var id: String?
    var platform_id: String?
    var status: String?
    var time: String?
    var type: String?
    var hash: String?
    
    enum CodingKeys: String, CodingKey {
        case address
        case amount
        case confirmations
        case currency_id
        case destination_tag
        case fee
        case fee_currency_id
        case id
        case platform_id
        case status
        case time
        case type
        case hash
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        amount = try container.decode(String.self, forKey: .amount)
        confirmations = try container.decode(Int.self, forKey: .confirmations)
        currency_id = try container.decode(String.self, forKey: .currency_id)
        destination_tag = try container.decode(String.self, forKey: .destination_tag)
        fee = try container.decode(String.self, forKey: .fee)
        fee_currency_id = try container.decode(String.self, forKey: .fee_currency_id)
        id = try container.decode(String.self, forKey: .id)
        platform_id = try container.decode(String.self, forKey: .platform_id)
        status = try container.decode(String.self, forKey: .status)
        time = try container.decode(String.self, forKey: .time)
        type = try container.decode(String.self, forKey: .type)
        address = try container.decode(String.self, forKey: .address)
        if let hash =  try container.decodeIfPresent(String.self, forKey: .hash) {
            self.hash = hash
        }
    }
}

struct ValidateAddressResponse: Codable {
    var data: String?
    var type: String?
    var id: String?
    var errorCode: String?
    
    enum CodingKeys: String, CodingKey {
        case data, id, type, errorCode
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decodeIfPresent(String.self, forKey: .data)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        errorCode = try container.decodeIfPresent(String.self, forKey: .errorCode)
    }
}
