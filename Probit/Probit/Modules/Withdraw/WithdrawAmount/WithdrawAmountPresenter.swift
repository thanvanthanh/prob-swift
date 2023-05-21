
import Foundation

class WithdrawAmountPresenter: ViewToPresenterWithdrawAmountProtocol {
    
    // MARK: Properties
    var view: PresenterToViewWithdrawAmountProtocol?
    var interactor: PresenterToInteractorWithdrawAmountProtocol?
    var router: PresenterToRouterWithdrawAmountProtocol?
    var currency: WalletCurrency? { interactor?.currency }
    
    func gotoAddressView(withdrawRequest: WithdrawRequest) {
        router?.gotoAddressView(withdrawRequest: withdrawRequest)
    }
    
    func getConfiguration() {
        view?.showLoading()
        interactor?.getConfig(completed: { [weak self] in
            guard let `self` = self else { return }
            let withdrawConfig = self.interactor?.generateCurrentPlatformContract()
            let dictionary = self.interactor?.configuration?.dictionary
            let selectedPlatform = self.interactor?.platformSelected

            DispatchQueue.main.async {
                self.view?.showContract(withdrawConfig: withdrawConfig,
                                        dictionary: dictionary, platform: selectedPlatform)
                self.view?.hideLoading()
            }
        })
    }
}

extension WithdrawAmountPresenter: InteractorToPresenterWithdrawAmountProtocol {
}
