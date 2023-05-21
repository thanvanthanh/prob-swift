
import Foundation

class GetMarketInfoAction: ProductAction<BaseProductResponse<MarketInfo>> {
    
    private var serviceType: String
    
     init(serviceType: String, dataSource: ProductService) {
         self.serviceType = serviceType
        super.init(dataSource: dataSource)
    }
    
    override func apiCall(callback: @escaping (Result<BaseProductResponse<MarketInfo>, ServiceError>) -> Void) {
        dataSource?.getMarketInfo(callback: callback)
    }
}
