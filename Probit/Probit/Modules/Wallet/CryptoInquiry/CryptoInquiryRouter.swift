
import Foundation
import UIKit

class CryptoInquiryRouter: PresenterToRouterCryptoInquiryProtocol {
    func showScreen(data: [WalletCurrency]) {
        if let destinationVC = self.createModule(data: data) as? CryptoInquiryViewController {
            destinationVC.getRootTabbarViewController().push(viewController: destinationVC, isAnimated: true, ishidesBottomBar: true)
        }
    }
    
    func setupRootView() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule()
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(data: [WalletCurrency] = []) -> UIViewController {
        let storyboard = UIStoryboard(name: "Wallet", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:CryptoInquiryViewController.self)
        
        let presenter: ViewToPresenterCryptoInquiryProtocol & InteractorToPresenterCryptoInquiryProtocol = CryptoInquiryPresenter(currencies: data)        
        viewController.presenter = presenter
        viewController.presenter?.router = CryptoInquiryRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = CryptoInquiryInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func showStakeDetail(stakeEvent: StakeEventModel,
                         stakeCurrency: StakeCurrency?,
                         walletCurrency: WalletCurrency) {
        StakeDetailsRouter(parentTypeVC: .WALLET).showScreen(stakeEvent: stakeEvent,
                                                             stakeCurrency: stakeCurrency,
                                                             walletCurrency: walletCurrency)
    }
    
    func showCryptoTransfer(walletCurrency: WalletCurrency) {
        CryptoTransfersRouter().showScreen(openAlone: true, data: walletCurrency)
    }
}
