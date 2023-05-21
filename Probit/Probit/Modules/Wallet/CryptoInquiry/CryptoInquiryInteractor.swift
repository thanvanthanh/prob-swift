
import Foundation

class CryptoInquiryInteractor: PresenterToInteractorCryptoInquiryProtocol {
    // MARK: Properties
    var presenter: InteractorToPresenterCryptoInquiryProtocol?
    
    var stakeCurrencies: [StakeCurrency] = []
    
    func getData() {
        StakeAPI.shared.getStakeCurrency() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let currencyData):
                self.stakeCurrencies = currencyData.data
                self.presenter?.getDataSuccess()
                
            case let .failure(error):
                self.presenter?.getDataFailed(error)
            }
        }
    }
}
