
import Foundation

class DepositPresenter: ViewToPresenterDepositProtocol {
    // MARK: Properties
    var view: PresenterToViewDepositProtocol?
    var interactor: PresenterToInteractorDepositProtocol?
    var router: PresenterToRouterDepositProtocol?
}

extension DepositPresenter: InteractorToPresenterDepositProtocol {
    func handerApiError(error: ServiceError) {
        view?.hideLoading()
        view?.showError(error: error)
        view?.updateUI()
    }
    
    func getDataSuccess() {
        view?.hideLoading()
        view?.updateUI()
    }
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.getData()
    }
}
