
import Foundation

class WithdrawAPI: BaseAPI<WithdrawServiceConfiguration> {
    static let shared = WithdrawAPI()
    
    func withdraw(request: WithdrawRequest, completionHandler: @escaping (Result<WidthdrawResponse, ServiceError>) -> Void) {
        fetchData(configuration: .withdraw(currency_id: request.currency_id,
                                           platform_id: request.selectedPlatform?.id ?? "",
                                           fee_currency_id: request.fee_currency_id,
                                           address: request.address,
                                           destination_tag: request.destination_tag,
                                           amount: request.amount,
                                           tfa_session_id: request.tfa_session_id),
                  responseType: WidthdrawResponse.self) { result in
            completionHandler(result)
        }
    }
    
    func checkWalletAddress(request: WithdrawRequest, completionHandler: @escaping (Result<ValidateAddressResponse, ServiceError>) -> Void) {
        fetchData(configuration: .validateWalletAddress(currency_id: request.currency_id,
                                                        platform_id: request.selectedPlatform?.id ?? "",
                                                        address: request.address,
                                                        destinationTag: request.destination_tag),
                  responseType: ValidateAddressResponse.self) { result in
            completionHandler(result)
        }
    }
}
