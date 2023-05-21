
import Foundation

struct WalletEndpoint: Configuration {
    var baseURL: String {
        return Constant.Server.baseAPIURL
    }
    
    var path: String {
        return "api/exchange/v1/balance"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: Task {
        return .requestParameters(parameters: [:])
    }
    
    var headers: [String : String]? {
        return AppConstant.authorizationHeader
    }
    
    var data: Data? {
        return nil
    }
}

class GetUserBalanceAction: BaseAPI<WalletEndpoint> {
    
    func apiCall(completionHandler: @escaping (Result<GetUserBalanceResponse, ServiceError>) -> Void) {
        fetchData(configuration: WalletEndpoint(), responseType: GetUserBalanceResponse.self, completionHandler: completionHandler)
    }
}
