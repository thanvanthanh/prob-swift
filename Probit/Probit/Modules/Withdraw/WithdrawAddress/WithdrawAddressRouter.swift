
import Foundation
import UIKit

class WithdrawAddressRouter: PresenterToRouterWithdrawAddressProtocol {
    func showScreen(withdrawRequest: WithdrawRequest) {
        let destinationVC = self.createModule(withdrawRequest: withdrawRequest)
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    func gotoReviewDetail(withdraw: WithdrawRequest) {
        WithdrawReviewRouter().showScreen(withdrawRequest: withdraw)
    }
    
    // MARK: Static methods
    func createModule(withdrawRequest: WithdrawRequest) -> WithdrawAddressViewController {
        let storyboard = UIStoryboard(name: "WithdrawAddress", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:WithdrawAddressViewController.self)
        
        let presenter: ViewToPresenterWithdrawAddressProtocol & InteractorToPresenterWithdrawAddressProtocol = WithdrawAddressPresenter.init(withdraw: withdrawRequest)
        
        viewController.presenter = presenter
        viewController.presenter?.router = WithdrawAddressRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = WithdrawAddressInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
