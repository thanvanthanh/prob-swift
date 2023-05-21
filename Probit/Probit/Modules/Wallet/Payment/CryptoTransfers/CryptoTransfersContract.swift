
import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewCryptoTransfersProtocol: BaseViewProtocol {
    func bindData(_ data: WalletCurrency)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterCryptoTransfersProtocol {
    var view: PresenterToViewCryptoTransfersProtocol? { get set }
    var interactor: PresenterToInteractorCryptoTransfersProtocol? { get set }
    var router: PresenterToRouterCryptoTransfersProtocol? { get set }
    var buyCryptoModel: BuyCryptoModel? { get set }
    func fetchData()
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorCryptoTransfersProtocol {
    var presenter: InteractorToPresenterCryptoTransfersProtocol? { get set }
    func getCoinStatus()
    var profileInfo: ProfileInfo? { get set }
    var currencies: [WalletCurrency]? { get set }
    var currency: WalletCurrency? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterCryptoTransfersProtocol {
    func updateCoinStatus()
    func updateBuyCryptoModel(buyCryptoModel: BuyCryptoModel?)
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterCryptoTransfersProtocol {
}
