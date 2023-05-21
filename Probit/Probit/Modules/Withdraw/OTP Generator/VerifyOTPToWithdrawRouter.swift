
import Foundation
import UIKit

class VerifyOTPToWithdrawRouter: PresenterToRouterVerifyOTPToWithdrawProtocol {
    
    func showScreen(tfaState: WithdrawVerificationResponse, withdrawRequest: WithdrawRequest? = nil) {
        let destinationVC = self.createModule(tfaState: tfaState, withdrawRequest: withdrawRequest)
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    // MARK: Static methods
    func createModule(tfaState: WithdrawVerificationResponse, withdrawRequest: WithdrawRequest? = nil) -> UIViewController {
        let storyboard = UIStoryboard(name: "VerifyOTPToWithdraw", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:VerifyOTPToWithdrawViewController.self)
        
        let presenter: ViewToPresenterVerifyOTPToWithdrawProtocol & InteractorToPresenterVerifyOTPToWithdrawProtocol = VerifyOTPToWithdrawPresenter()
        let entity: InteractorToVerifyCodeEntityProtocol = VerifyCodeEntity()

        viewController.presenter = presenter
        viewController.presenter?.router = VerifyOTPToWithdrawRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = VerifyOTPToWithdrawInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.entity = entity
        viewController.presenter?.interactor?.withdrawRequest = withdrawRequest
        viewController.presenter?.interactor?.tfaState = tfaState

        return viewController
    }
    
    func gotoVerificationViaEmail(tfaState: TFAState, type: AuthenticationMethod, request: WithdrawRequest) {
        VerificationRouter().showScreen(email: "", type: .withdraw, tfaState: tfaState, verificationType: type, withdrawRequest: request)
    }
    
    func gotoSuccessFulScreen() {
        WithdrawSuccessfulRouter().showScreen()
    }
}
