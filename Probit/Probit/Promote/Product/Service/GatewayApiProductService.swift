
import Foundation

class GatewayApiProductService: ProductService {

    private var config: PromoteConfiguration?
    private var api: GatewayProductApi
    
    init(config: PromoteConfiguration? = nil) {
        self.config = config
        self.api = GatewayProductApiFactory().api()
    }
    
    func getCurrencyWithPlatform(callback: @escaping (Result<BaseProductResponse<Currency>, ServiceError>) -> Void) {
        api.getCurrencyWithPlatform(completionHandler: callback)
    }
    
    func getMarket(serviceType: String, callback: @escaping (Result<BaseProductResponse<Market>, ServiceError>) -> Void) {
        api.getMarket(serviceType: serviceType, completionHandler: callback)
    }
    
    func getMarketInfo(callback: @escaping (Result<BaseProductResponse<MarketInfo>, ServiceError>) -> Void) {
        api.getMarketInfo(completionHandler: callback)
    }
    
    func getTicker(callback: @escaping (Result<BaseProductResponse<Ticker>, ServiceError>) -> Void) {
        api.getTicker(completionHandler: callback)
    }
    
    func getStakeCurrencyAction(callback: @escaping (Result<BaseProductResponse<StakeCurrency>, ServiceError>) -> Void) {
        api.getStakeCurrencyAction(completionHandler: callback)
    }
    
    func getStakeEventAction(callback: @escaping (Result<BaseProductResponse<StakeEvent>, ServiceError>) -> Void) {
        api.getStakeEventAction(completionHandler: callback)
    }
    
    func getWithdrawLimit(callback: @escaping (Result<WithdrawLimit, ServiceError>) -> Void) {
        api.getWithdrawLimit(callback: callback)
    }
    
    func getFixedRate(quote: String, callback: @escaping (Result<FixedRate, ServiceError>) -> Void) {
        api.getFixedRate(quote: quote, callback: callback)
    }
    
    func getMarketTag(callback: @escaping (Result<BaseProductResponse<MarketTag>, ServiceError>) -> Void) {
        api.getMarketTag(callback: callback)
    }
    
    func getMarketTagSuggestion(callback: @escaping (Result<BaseProductResponse<MarketTagSuggestion>, ServiceError>) -> Void) {
        api.getMarketTagSuggestion(callback: callback)
    }

}
