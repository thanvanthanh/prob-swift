
import Foundation

enum AuthenticationMethod: String {
    case totp   = "totp"
    case email  = "email"
    case sms    = "sms"
    case phone  = "phone"
    case u2f    = "u2f"
    case signup = "signup"

}

class WithdrawReviewInteractor: PresenterToInteractorWithdrawReviewProtocol {
    
    // MARK: Properties
    var presenter: InteractorToPresenterWithdrawReviewProtocol?
    var entity: InteractorToEntityWithdrawProtocol?

    func excuteWithdraw(request: WithdrawRequest) {
        entity?.excuteWithdraw(request: request, completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(_):
                self.presenter?.showWithdrawResult(response: nil)
            case .failure(_):
                self.detectTFAMothod(request: request)
            }
        })
    }
    
    func detectTFAMothod(request: WithdrawRequest) {
        self.entity?.getTFAMethod(request: request, completionHandler: { [weak self] results in
            guard let `self` = self else { return }
            switch results {
            case let .success(response):
                self.presenter?.showWithdrawResult(response: response)
            case let .failure(error):
                self.presenter?.withdrawFail(error: error)
            }
        })
    }
    
    func sendTFAEmail(sessionId: String) {
        entity?.sendTFAEmail(sessionId: sessionId)
    }
}
