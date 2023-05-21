//
//  HomeRouter.swift
//  Probit
//
//  Created by Nguyen Quang on 23/08/2022.
//  
//

import Foundation
import UIKit

class HomeRouter: PresenterToRouterHomeProtocol {
    func showScreen() {
        let destinationVC = self.createModule()
        destinationVC.getRootViewController().navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func changeSelectedTabbar() {
        let destinationVC = self.createModule()
        destinationVC.getRootTabbarViewController().tabBarController?.selectedIndex = TabBarItem.home.rawIndex
    }
    
    func setupRootView() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = self.createModule()
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule() -> UIViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType: HomeViewController.self)
        
        let presenter: ViewToPresenterHomeProtocol & InteractorToPresenterHomeProtocol = HomePresenter()
        let entity: InteractorToEntityHomeProtocol = HomeEntity()
        
        viewController.presenter = presenter
        viewController.presenter?.router = HomeRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = HomeInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.interactor?.entity = entity
        
        return viewController
    }
    
    func navigateToBuyCrypto() {
        BuyCryptoRouter().showScreen(type: .toHome)
    }
    
    func navigateToLogin() {        
        LoginRouter().showScreen()
    }
    
    func navigateToMore() {
        MoreRouter().showScreen()
    }
    
    func navigateToExclusive() {
        CommonWebViewRouter().showScreen(titleBackScreen: "navigationbar_home".Localizable(),
                                         urlString: AppConstant.Link.exclusive,
                                         titleNavigation: "v2icon_home_exclusive".Localizable() + " - ProBit Global")
    }
    
    func navigateToIEO() {
        CommonWebViewRouter().showScreen(titleBackScreen: "navigationbar_home".Localizable(),
                                         urlString: AppConstant.Link.ieo,
                                         titleNavigation: "v2icon_home_ieo".Localizable() + " - ProBit Global")
    }
    
    func navigateToWebView(link: String, title: String) {
        CommonWebViewRouter().showScreen(titleBackScreen: "navigationbar_home".Localizable(),
                                         urlString: link,
                                         titleNavigation: title)
    }
    
    func navigateToAppLock() {
        InputPinRouter().showScreen(type: .login)
    }
    
    func navigateToExchange(from vc: UIViewController) {
        vc.tabBarController?.selectedIndex = TabBarItem.exchange.rawIndex
    }
    
    func navigateToExchangeSearch(keyword: String) {
        SearchExchangeRouter().showScreen(keyword: keyword)
    }
    
    func navigateToExchangeDetail(with exchangeTicker: ExchangeTicker) {
        ExchangeDetailRouter().showScreen(exchange: exchangeTicker)
    }
    
    func navigateToExchangeDetail(with exchangeId: String) {
        ExchangeDetailRouter().showScreen(exchangeId: exchangeId)
    }
}
