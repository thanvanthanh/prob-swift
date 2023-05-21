
import Foundation

class CryptoInquiryPresenter: ViewToPresenterCryptoInquiryProtocol {
    
    // MARK: Properties
    var view: PresenterToViewCryptoInquiryProtocol?
    var interactor: PresenterToInteractorCryptoInquiryProtocol?
    var router: PresenterToRouterCryptoInquiryProtocol?
    private var currencies: [WalletCurrency] = []
    var stakeCurrencies: [StakeCurrency] {
        return interactor?.stakeCurrencies ?? []
    }
    
    required init(currencies: [WalletCurrency]) {
        self.currencies = currencies
    }
    
    func search(_ text: String){
        let result = currencies.filter { currency in
            guard let id = currency.id, let name = currency.displayName else {
                return false
            }
            return id.lowercased().contains(text.lowercased()) || name.lowercased().contains(text.lowercased())
        }
        view?.bindData(result)
    }
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.getData()
    }
    
    func didSelectItem(with walletCurrency: WalletCurrency) {
        let currency = walletCurrency
        if let stakeEvent = currency.stakeEvent {
            let stakeCurrency = stakeCurrencies.first { data in
                currency.id == data.currencyId
            }
            
            router?.showStakeDetail(stakeEvent: stakeEvent,
                                    stakeCurrency: stakeCurrency,
                                    walletCurrency: currency)
            
        } else {
            router?.showCryptoTransfer(walletCurrency: currency)
        }
    }
}

// MARK: - InteractorToPresenter
extension CryptoInquiryPresenter: InteractorToPresenterCryptoInquiryProtocol {
    func getDataSuccess() {
        view?.hideLoading()
    }
    
    func getDataFailed(_ error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
    }
}
