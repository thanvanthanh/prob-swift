
import Foundation
import UIKit

class WithdrawAmountRouter: PresenterToRouterWithdrawAmountProtocol {
    func gotoAddressView(withdrawRequest: WithdrawRequest) {
        WithdrawAddressRouter().showScreen( withdrawRequest: withdrawRequest)
    }
    
    func showScreen(currency: WalletCurrency) {
        let destinationVC = self.createModule(currency: currency)
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    // MARK: Static methods
    func createModule(currency: WalletCurrency) -> WithdrawAmountViewController {
        let storyboard = UIStoryboard(name: "WithdrawAmount", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:WithdrawAmountViewController.self)
        
        let presenter: ViewToPresenterWithdrawAmountProtocol & InteractorToPresenterWithdrawAmountProtocol = WithdrawAmountPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = WithdrawAmountRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = WithdrawAmountInteractor(currency: currency)
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
}
