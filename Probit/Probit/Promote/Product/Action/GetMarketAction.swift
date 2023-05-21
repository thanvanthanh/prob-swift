
import Foundation

class GetMarketAction: ProductAction<BaseProductResponse<Market>> {
    
    private var serviceType: String
    
     init(serviceType: String, dataSource: ProductService) {
        self.serviceType = serviceType
        super.init(dataSource: dataSource)
    }
    
    override func apiCall(callback: @escaping (Result<BaseProductResponse<Market>, ServiceError>) -> Void) {
        dataSource?.getMarket(serviceType: self.serviceType, callback: callback)
    }
}
