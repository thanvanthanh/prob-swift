
import Foundation


enum ProductEndpoint {
    case getCurrencyWithPlatform
    case getMarket(serviceType: String)
    case getMarketInfo
    case getTicker
    case getStakeCurrency
    case getStakeEvent
    case getWithdrawLimit
    case getFixedRate(quote: String)
    case getMarketSuggestion
    case getMarketTag
    case getMarketIndex
}

extension ProductEndpoint: Configuration {
    var baseURL: String {
        switch self {
        case .getMarketTag, .getMarketIndex, .getMarketSuggestion:
            return Constant.Server.baseStaticURL
        default:
            return Constant.Server.baseAPIURL
        }
//        return "https://www.probit.com/"
    }
    
    var path: String {
        switch self {
        case .getMarket:
            return "api/exchange/v1/market"
        case .getCurrencyWithPlatform:
            return "api/exchange/v1/currency_with_platform"
        case .getMarketInfo:
            return "api/exchange/v1/market_info"
        case .getTicker:
            return "api/exchange/v1/ticker"
        case .getStakeCurrency:
            return "api/event/v1/stake_currency"
        case .getStakeEvent:
            return "api/event/v1/stake_event"
        case .getWithdrawLimit:
            return "api/exchange/v1/withdrawal_limit"
        case .getFixedRate:
            return "api/exchange/v1/fixed_rate"
        case .getMarketIndex:
            return "ua-cfg/markettag-index.json"
        case .getMarketSuggestion:
            return "ua-cfg/marketlist-tag-suggestion.json"
        case .getMarketTag:
            return "ua-cfg/markettag.json"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: Task {
        switch self {
        case .getCurrencyWithPlatform,
                .getStakeEvent,
                .getStakeCurrency,
                .getTicker,
                .getMarketInfo,
                .getWithdrawLimit,
                .getMarketSuggestion,
                .getMarketIndex,
                .getMarketTag:
            return .requestParameters(parameters: [:])
        case .getMarket(let serviceType):
            return .requestParameters(parameters: ["service_type" : serviceType])
        case .getFixedRate(let quote):
            return .requestParameters(parameters: ["quote" : quote])
            
        }
    }
    
    var headers: [String : String]? {
        return AppConstant.authorizationHeader
    }
    
    var data: Data? {
        return nil
    }
}

protocol GatewayProductApi {
    func getCurrencyWithPlatform(completionHandler: @escaping (Result<BaseProductResponse<Currency>, ServiceError>) -> Void)
    func getMarket(serviceType: String, completionHandler: @escaping (Result<BaseProductResponse<Market>, ServiceError>) -> Void)
    func getMarketInfo(completionHandler: @escaping (Result<BaseProductResponse<MarketInfo>, ServiceError>) -> Void)
    func getTicker(completionHandler: @escaping (Result<BaseProductResponse<Ticker>, ServiceError>) -> Void)
    func getStakeCurrencyAction(completionHandler: @escaping (Result<BaseProductResponse<StakeCurrency>, ServiceError>) -> Void)
    func getStakeEventAction(completionHandler: @escaping (Result<BaseProductResponse<StakeEvent>, ServiceError>) -> Void)
    func getWithdrawLimit(callback: @escaping (Result<WithdrawLimit, ServiceError>) -> Void)
    func getFixedRate(quote: String, callback: @escaping (Result<FixedRate, ServiceError>) -> Void)
    func getMarketTag(callback: @escaping (Result<BaseProductResponse<MarketTag>, ServiceError>) -> Void)
    func getMarketTagSuggestion(callback: @escaping (Result<BaseProductResponse<MarketTagSuggestion>, ServiceError>) -> Void)
}

class ProbitGatewayProductApi: BaseAPI<ProductEndpoint>, GatewayProductApi {
        
    final class Builder {
        public static func build() -> GatewayProductApi {
            return ProbitGatewayProductApi()
        }
    }
    
    private override init() {
        super.init()
    }
    
    func getCurrencyWithPlatform(completionHandler: @escaping (Result<BaseProductResponse<Currency>, ServiceError>) -> Void) {
        fetchData(configuration: .getCurrencyWithPlatform, responseType: BaseProductResponse.self, completionHandler: completionHandler)
    }
    
    func getMarket(serviceType: String, completionHandler: @escaping (Result<BaseProductResponse<Market>, ServiceError>) -> Void) {
        fetchData(configuration: .getMarket(serviceType: serviceType), responseType: BaseProductResponse.self, completionHandler: completionHandler)
    }
    
    func getMarketInfo(completionHandler: @escaping (Result<BaseProductResponse<MarketInfo>, ServiceError>) -> Void) {
        fetchData(configuration: .getMarketInfo, responseType: BaseProductResponse<MarketInfo>.self) { result in
            switch result {
            case.success(let response):
                completionHandler(.success(response.global()))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func getTicker(completionHandler: @escaping (Result<BaseProductResponse<Ticker>, ServiceError>) -> Void) {
        fetchData(configuration: .getTicker, responseType: BaseProductResponse.self, completionHandler: completionHandler)
    }
    func getStakeCurrencyAction(completionHandler: @escaping (Result<BaseProductResponse<StakeCurrency>, ServiceError>) -> Void) {
        fetchData(configuration: .getStakeCurrency, responseType: BaseProductResponse.self, completionHandler: completionHandler)
    }
    
    func getStakeEventAction(completionHandler: @escaping (Result<BaseProductResponse<StakeEvent>, ServiceError>) -> Void) {
        fetchData(configuration: .getStakeEvent, responseType: BaseProductResponse.self, completionHandler: completionHandler)
    }
    
    func getWithdrawLimit(callback: @escaping (Result<WithdrawLimit, ServiceError>) -> Void) {
        fetchData(configuration: .getWithdrawLimit, responseType: WithdrawLimit.self, completionHandler: callback)
    }
    
    func getFixedRate(quote: String, callback: @escaping (Result<FixedRate, ServiceError>) -> Void) {
        fetchData(configuration: .getFixedRate(quote: quote), responseType: FixedRate.self, completionHandler: callback)
    }

    func getMarketTag(callback: @escaping (Result<BaseProductResponse<MarketTag>, ServiceError>) -> Void) {
        fetchData(configuration: .getMarketTag, responseType: BaseProductResponse.self, completionHandler: callback)
    }
    
    func getMarketTagSuggestion(callback: @escaping (Result<BaseProductResponse<MarketTagSuggestion>, ServiceError>) -> Void) {
        fetchData(configuration: .getMarketSuggestion, responseType: BaseProductResponse.self, completionHandler: callback)
    }
}
