
import Foundation

class BaseProductResponse<T: Codable>: Codable {
    var data: [T]
    
}

extension BaseProductResponse where T == MarketInfo {
    func global() -> Self {
        self.data = data.global()
        return self
    }
}
