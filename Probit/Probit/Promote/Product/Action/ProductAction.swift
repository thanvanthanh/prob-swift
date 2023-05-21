
import Foundation

class ProductAction<T> {
    
    internal var dataSource: ProductService?
    
    init(dataSource: ProductService) {
        self.dataSource = dataSource
    }
    
    public func apiCall(callback: @escaping (Result<T, ServiceError>) -> Void){
        fatalError("This method must be overridden by the subclass")
    }
}
