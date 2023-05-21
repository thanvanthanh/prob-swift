
import Foundation

class GetWithdrawLimitAction: ProductAction<WithdrawLimit> {
    override func apiCall(callback: @escaping (Result<WithdrawLimit, ServiceError>) -> Void) {
        dataSource?.getWithdrawLimit(callback: callback)
    }
}
