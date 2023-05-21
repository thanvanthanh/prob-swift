
import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewCryptoInquiryProtocol: BaseViewProtocol {
    func bindData(_ data: [WalletCurrency])
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterCryptoInquiryProtocol {
    var view: PresenterToViewCryptoInquiryProtocol? { get set }
    var interactor: PresenterToInteractorCryptoInquiryProtocol? { get set }
    var router: PresenterToRouterCryptoInquiryProtocol? { get set }
    init(currencies: [WalletCurrency])
    
    var stakeCurrencies: [StakeCurrency] { get }
    
    func viewDidLoad()
    func search(_ text: String)
    func didSelectItem(with walletCurrency: WalletCurrency)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorCryptoInquiryProtocol {
    var presenter: InteractorToPresenterCryptoInquiryProtocol? { get set }
    
    var stakeCurrencies: [StakeCurrency] { get set }
    
    func getData()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterCryptoInquiryProtocol {
    func getDataSuccess()
    func getDataFailed(_ error: ServiceError)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterCryptoInquiryProtocol {
    func showStakeDetail(stakeEvent: StakeEventModel,
                         stakeCurrency: StakeCurrency?,
                         walletCurrency: WalletCurrency)
    func showCryptoTransfer(walletCurrency: WalletCurrency)
}
