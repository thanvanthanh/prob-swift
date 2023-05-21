
import Foundation

class CryptoTransfersPresenter: ViewToPresenterCryptoTransfersProtocol {
    
    // MARK: Properties
    var view: PresenterToViewCryptoTransfersProtocol?
    var interactor: PresenterToInteractorCryptoTransfersProtocol?
    var router: PresenterToRouterCryptoTransfersProtocol?
    var currency: WalletCurrency? {
        interactor?.currency
    }
    var buyCryptoModel: BuyCryptoModel?
    var timer: Timer?
    
    func fetchData() {
        view?.showLoading()
        interactor?.getCoinStatus()
    }
    
    @objc func requestCoin() {
        interactor?.getCoinStatus()
    }
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
    
}

extension CryptoTransfersPresenter: InteractorToPresenterCryptoTransfersProtocol {
    func updateBuyCryptoModel(buyCryptoModel: BuyCryptoModel?) {
        self.buyCryptoModel = buyCryptoModel
    }
    
    func updateCoinStatus() {
        if let currency = currency {
            view?.bindData(currency)
            view?.hideLoading()
            DispatchQueue.main.asyncAfter(deadline: .now() + AppConstant.timeRequest, execute: {
                self.interactor?.getCoinStatus()
            })
        }
    }
}
