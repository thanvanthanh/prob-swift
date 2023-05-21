
import Foundation

class WithdrawVerificationAPI: BaseAPI<WithdrawVerificationConfiguration> {
    static let shared = WithdrawVerificationAPI()
    
    func startTFA(request: WithdrawRequest, completionHandler: @escaping (Result<WithdrawVerificationResponse, ServiceError>) -> Void) {
        let withdrawInformation = ["currency_id": request.currency_id,
                                   "platform_id": request.selectedPlatform?.id ?? "",
                                   "fee_currency_id": request.fee_currency_id,
                                   "address": request.address,
                                   "destination_tag": request.destination_tag,
                                   "amount": request.amount]
        let withdrawMessage = withdrawInformation.jsonStringRepresentation ?? ""
        fetchData(configuration: .twoFactorAuthentication(message: withdrawMessage),
                  responseType: WithdrawVerificationResponse.self) { result in
            completionHandler(result)
        }
    }
    
    func verifyCode(code: String, sessionId: String, type: AuthenticationMethod = .totp, completionHandler: @escaping (Result<WithdrawVerificationResponse, ServiceError>) -> Void) {
        fetchData(configuration: .validateCode(code: code, sessionId: sessionId, type: type),
                  responseType: WithdrawVerificationResponse.self) { result in
            completionHandler(result)
        }
    }
    
    func sendEmail(sessionId: String, completionHandler: @escaping (Result<WithdrawSendEmailResponse, ServiceError>) -> Void) {
        fetchData(configuration: .sendTFAEmail(sessionId: sessionId),
                  responseType: WithdrawSendEmailResponse.self) { result in
            completionHandler(result)
        }
    }
    
    func sendSms(sessionId: String, completionHandler: @escaping (Result<WithdrawSendEmailResponse, ServiceError>) -> Void) {
        fetchData(configuration: .sendTFASms(sessionId: sessionId),
                  responseType: WithdrawSendEmailResponse.self) { result in
            completionHandler(result)
        }
    }
    
    func callPhone(sessionId: String, completionHandler: @escaping (Result<WithdrawSendEmailResponse, ServiceError>) -> Void) {
        fetchData(configuration: .callTFAPhone(sessionId: sessionId),
                  responseType: WithdrawSendEmailResponse.self) { result in
            completionHandler(result)
        }
    }
    
    func startTFANew(purpose: PURPOSE,
                     completionHandler: @escaping (Result<WithdrawVerificationResponse, ServiceError>) -> Void) {
        fetchData(configuration: .tfaStartNew(purpose: purpose, authnDetails: nil),
                  responseType: WithdrawVerificationResponse.self) { result in
            completionHandler(result)
        }
    }
    
    func startTFANewV1(purpose: PURPOSE,
                       completionHandler: @escaping (Result<WithdrawVerificationResponse, ServiceError>) -> Void) {
        fetchData(configuration: .tfaStartNewV1(purpose: purpose), responseType: WithdrawVerificationResponse.self, completionHandler: completionHandler)
    }
}
