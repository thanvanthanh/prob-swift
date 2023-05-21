
import Foundation

class GetCurrencyWithPlatformAction: ProductAction<BaseProductResponse<Currency>> {
    override func apiCall(callback: @escaping (Result<BaseProductResponse<Currency>, ServiceError>) -> Void) {
        dataSource?.getCurrencyWithPlatform(callback: callback)
    }
}
