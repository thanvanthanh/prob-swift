
import Foundation

class GatewayProductApiFactory: GatewayBaseApiFactory {
     init(config: PromoteConfiguration? = nil) {
        super.init(acceptLanguage: config?.acceptLanguage)
     }
    
    public func api() -> GatewayProductApi {
        return ProbitGatewayProductApi.Builder.build()
    }
    
}

