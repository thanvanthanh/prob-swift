
import Foundation

class WithdrawAddressInteractor: PresenterToInteractorWithdrawAddressProtocol {
    // MARK: Properties
    var presenter: InteractorToPresenterWithdrawAddressProtocol?
    
    func validateAddress(request: WithdrawRequest) {
        WithdrawAPI.shared.checkWalletAddress(request: request, completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.presenter?.addressValid()
                break
            case .failure(_):
                self.presenter?.addressInvalid()
                break
            }
        })
    }
}
