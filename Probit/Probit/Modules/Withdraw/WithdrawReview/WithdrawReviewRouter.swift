
import Foundation
import UIKit

class WithdrawReviewRouter: PresenterToRouterWithdrawReviewProtocol {
    func showScreen(withdrawRequest: WithdrawRequest) {
        let destinationVC = self.createModule(withdrawRequest: withdrawRequest)
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    // MARK: Static methods
    func createModule(withdrawRequest: WithdrawRequest) -> WithdrawReviewViewController {
        let storyboard = UIStoryboard(name: "WithdrawReview", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:WithdrawReviewViewController.self)
        
        let presenter: ViewToPresenterWithdrawReviewProtocol & InteractorToPresenterWithdrawReviewProtocol = WithdrawReviewPresenter.init(withdraw: withdrawRequest)
        let entity: InteractorToEntityWithdrawProtocol = WithdrawEntity()

        viewController.presenter = presenter
        viewController.presenter?.router = WithdrawReviewRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = WithdrawReviewInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.entity = entity
        return viewController
    }
    
    func popToRootView() {
        UIViewController().getRootTabbarViewController().popToRootViewController(animated: false)
    }
}
