//
//  KycListCountriesRouter.swift
//  Probit
//
//  Created by Bradley Hoang on 02/11/2022.
//  
//

import UIKit

class KycListCountriesRouter: PresenterToRouterKycListCountriesProtocol {
    func showScreen(delegate: KycListCountriesDelegate,
                    selectedCountry: Country?) {
        let destinationVC = createModule(delegate: delegate,
                                         selectedCountry: selectedCountry)
        destinationVC.getRootTabbarViewController().pushViewController(destinationVC, animated: true)
    }
    
    func setupRootView(delegate: KycListCountriesDelegate,
                       selectedCountry: Country?) {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appdelegate.window else { return }
        
        let destinationVC = createModule(delegate: delegate,
                                         selectedCountry: selectedCountry)
        window.rootViewController = UINavigationController.init(rootViewController: destinationVC)
        window.makeKeyAndVisible()
    }
    
    // MARK: Static methods
    func createModule(delegate: KycListCountriesDelegate,
                      selectedCountry: Country?) -> UIViewController {
        let storyboard = UIStoryboard(name: "KycListCountries", bundle: nil)
        let viewController = storyboard.instantiateViewController(viewControllerType:KycListCountriesViewController.self)
        
        let presenter: ViewToPresenterKycListCountriesProtocol & InteractorToPresenterKycListCountriesProtocol = KycListCountriesPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = KycListCountriesRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.selectedCountry = selectedCountry
        viewController.presenter?.delegate = delegate
        viewController.presenter?.interactor = KycListCountriesInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func popToPreviousView(from vc: UIViewController) {
        vc.pop()
    }
}
