
import Foundation

class VerifyOTPToWithdrawInteractor: PresenterToInteractorVerifyOTPToWithdrawProtocol {
    
    // MARK: Properties
    var presenter: InteractorToPresenterVerifyOTPToWithdrawProtocol?
    var entity: InteractorToVerifyCodeEntityProtocol?
    var withdrawRequest: WithdrawRequest?
    var tfaState: WithdrawVerificationResponse?

    func excuteVerifyCode(code: String, sessionId: String) {
        entity?.excuteVerifyCode(code: code, sessionId: sessionId, completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case let .success(response):
                if response.success == true {
                    self.presenter?.showVerificationResult(response: response)
                } else {
                    self.presenter?.verifyCodeFail(error: ServiceError(issueCode: .TOTP_INVALID))
                }
            case let .failure(error):
                self.presenter?.verifyCodeFail(error: error)
            }
        })
    }
    
    func excuteWithdraw() {
        guard var request = self.withdrawRequest else {
            self.presenter?.verifyCodeFail(error: ServiceError(issueCode: .TOTP_INVALID))
            return
        }
        request.tfa_session_id = tfaState?.state?.sessId ?? ""
        entity?.excuteWithdraw(request: request, completionHandler: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(_):
                self.presenter?.withdrawSuccessful()
            case .failure(let error):
                self.presenter?.verifyCodeFail(error: error)
            }
        })
    }
    
    func sendTFAEmail(sessionId: String) {
        entity?.sendTFAEmail(sessionId: sessionId)
    }
    
    func sendTFASms(sessionId: String) {
        entity?.sendTFASms(sessionId: sessionId)
    }
    
    func callTFAPhone(sessionId: String) {
        entity?.callTFAPhone(sessionId: sessionId)
    }
}
