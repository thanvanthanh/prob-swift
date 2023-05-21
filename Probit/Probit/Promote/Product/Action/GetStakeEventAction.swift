
import Foundation

class GetStakeEventAction: ProductAction<BaseProductResponse<StakeEvent>> {
    
    override func apiCall(callback: @escaping (Result<BaseProductResponse<StakeEvent>, ServiceError>) -> Void) {
        dataSource?.getStakeEventAction(callback: callback)
    }
}
