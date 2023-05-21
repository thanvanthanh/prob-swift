
import Foundation

class GetStakeCurrencyAction: ProductAction<BaseProductResponse<StakeCurrency>> {
    
    override func apiCall(callback: @escaping (Result<BaseProductResponse<StakeCurrency>, ServiceError>) -> Void) {
        dataSource?.getStakeCurrencyAction(callback: callback)
    }
}
