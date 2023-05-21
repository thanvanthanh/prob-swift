
import Foundation

struct FixedRate: Decodable {
    var data: [String : String]?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}
