
import Foundation

protocol ProductService {
    func getCurrencyWithPlatform(callback: @escaping (Result<BaseProductResponse<Currency>, ServiceError>) -> Void)
    func getTicker(callback: @escaping (Result<BaseProductResponse<Ticker>, ServiceError>) -> Void)
    func getMarket(serviceType: String, callback: @escaping (Result<BaseProductResponse<Market>, ServiceError>) -> Void)
    func getMarketInfo(callback: @escaping (Result<BaseProductResponse<MarketInfo>, ServiceError>) -> Void)
    func getStakeCurrencyAction(callback: @escaping (Result<BaseProductResponse<StakeCurrency>, ServiceError>) -> Void)
    func getStakeEventAction(callback: @escaping (Result<BaseProductResponse<StakeEvent>, ServiceError>) -> Void)
    func getWithdrawLimit(callback: @escaping (Result<WithdrawLimit, ServiceError>) -> Void)
    func getFixedRate(quote: String, callback: @escaping (Result<FixedRate, ServiceError>) -> Void)
    func getMarketTag(callback: @escaping (Result<BaseProductResponse<MarketTag>, ServiceError>) -> Void)
    func getMarketTagSuggestion(callback: @escaping (Result<BaseProductResponse<MarketTagSuggestion>, ServiceError>) -> Void)
}
