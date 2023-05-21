
import Foundation

class WithdrawAddressPresenter: ViewToPresenterWithdrawAddressProtocol {
    var withdrawRequest: WithdrawRequest?
    
    // MARK: Properties
    var view: PresenterToViewWithdrawAddressProtocol?
    var interactor: PresenterToInteractorWithdrawAddressProtocol?
    var router: PresenterToRouterWithdrawAddressProtocol?
    
    func gotoReviewDetailView() {
        guard let withdrawRequest = self.withdrawRequest else { return }
        router?.gotoReviewDetail(withdraw: withdrawRequest)
    }
    
    required init(withdraw: WithdrawRequest) {
        self.withdrawRequest = withdraw
    }
    
    func validateAddress() {
        guard let request = withdrawRequest else { return }
        view?.showLoading()
        interactor?.validateAddress(request: request)
    }
    
    func addressInvalid() {
        view?.hideLoading()
        view?.addressInvalid()
    }
    
    func addressValid() {
        view?.hideLoading()
        view?.addressValid()
    }
}

extension WithdrawAddressPresenter: InteractorToPresenterWithdrawAddressProtocol {
}
