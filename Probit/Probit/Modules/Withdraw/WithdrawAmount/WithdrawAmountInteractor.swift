
import Foundation

class WithdrawAmountInteractor: PresenterToInteractorWithdrawAmountProtocol {
    
    // MARK: Properties
    var presenter: InteractorToPresenterWithdrawAmountProtocol?
    var currency: WalletCurrency?
    var platformSelected: Platform?
    var networkFeeSelected: WithdrawalFee?
    var configuration: ConfigWdwarnModel?
    var withdrawalLimit: WithdrawLimit?

    required init(currency: WalletCurrency) {
        self.currency = currency
        self.platformSelected = currency.platform.first(where: {$0.withdrawalSuspended == false})
        self.networkFeeSelected = platformSelected?.withdrawalFee?.first
    }
    
    func getConfig(completed: @escaping() -> Void) {
        let group = DispatchGroup()
        group.enter()
        HomeAPI.shared.getProfileInfo2() { [weak self] result in
           guard let `self` = self else { return }
            group.leave()
           switch result {
           case .success(let res):
               self.configuration = res
           case .failure(_):
               break
           }
       }
        
        group.enter()
        ProbitGatewayProductApi.Builder.build().getWithdrawLimit(callback: { [weak self] result in
            guard let self = self else { return }
            group.leave()
            switch result {
            case .success(let withdrawLimit):
                self.withdrawalLimit = withdrawLimit
            case .failure(_):
                break
            }
        })
        
        group.notify(queue: .main) { 
            completed()
        }
    }
    
    func generateCurrentPlatformContract() -> ConfigWithdrawal? {
        return configuration?.withdrawal?
            .first(where: { $0.currencyID == platformSelected?.currencyID && ($0.platformID == platformSelected?.id || $0.platformID == "*") })
    }
}
