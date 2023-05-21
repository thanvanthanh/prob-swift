//
//  KycSelectCountryRouter.swift
//  Probit
//
//  Created by Bradley Hoang on 02/11/2022.
//  
//

import UIKit

class KycSelectCountryRouter: PresenterToRouterKycSelectCountryProtocol {
    func showScreen() {
        let destinationVC = createModule()
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = createModule()
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule() -> UIViewController {
        let storyboard = UIStoryboard(name: "KycSelectCountry", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:KycSelectCountryViewController.self)
        
        let presenter: ViewToPresenterKycSelectCountryProtocol & InteractorToPresenterKycSelectCountryProtocol = KycSelectCountryPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = KycSelectCountryRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = KycSelectCountryInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func navigateToKycListCountries(delegate: KycListCountriesDelegate,
                                    selectedCountry: Country?) {
        KycListCountriesRouter().showScreen(delegate: delegate,
                                            selectedCountry: selectedCountry)
    }
    
    func navigateToPersonalInfoInput() {
        KycPersonalInfoInputRouter().showScreen()
    }
}
