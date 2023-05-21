//
//  SplashViewController.swift
//  Probit
//
//  Created by Beacon on 21/08/2022.
//  
//

import UIKit

class SplashViewController: BaseViewController { 
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar(isHide: true)
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AppConstant.deviceUUID.isEmpty {
            AppConstant.deviceUUID = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.presenter?.navigateToLogin()
        }
    }

    // MARK: - Properties
    var presenter: ViewToPresenterSplashProtocol?
    
}

extension SplashViewController: PresenterToViewSplashProtocol{
    // TODO: Implement View Output Methods
}
