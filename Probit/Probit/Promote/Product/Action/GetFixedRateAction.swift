
import Foundation

class GetFixedRateAction: ProductAction<FixedRate> {
    private var quote: String
    
     init(quote: String, dataSource: ProductService) {
        self.quote = quote
        super.init(dataSource: dataSource)
    }
    
    override func apiCall(callback: @escaping (Result<FixedRate, ServiceError>) -> Void) {
        dataSource?.getFixedRate(quote: self.quote, callback: callback)
    }
}
