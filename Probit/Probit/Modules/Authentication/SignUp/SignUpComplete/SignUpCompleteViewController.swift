//
//  SignUpCompleteViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 22/08/2022.
//  
//

import UIKit

enum CompleteType {
    case signUp
    case changePassword
    case pinSetting
}

class SignUpCompleteViewController: BaseViewController {
    
    @IBOutlet weak var completeTitle: UILabel!
    @IBOutlet weak var willReturnLabel: UILabel!
    
    // MARK: - Properties
    var presenter: ViewToPresenterSignUpCompleteProtocol?
    var completeType: CompleteType = .signUp
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if self.completeType == .changePassword {
                let loginIndex = self.navigationController?.viewControllers.firstIndex(where: { $0 is LoginViewController }) ?? 0
                self.popToViewController(index: loginIndex, animation: true)
                return
            }
            
            if let appLockViewController = self.navigationController?.viewControllers.first(where: {$0.className == AppLockViewController.className}) {
                self.navigationController?.popToViewController(appLockViewController, animated: true)
            }

            if self.completeType == .signUp {
                LoginRouter().showScreen()
                var currentViewControllerStack = UIViewController().getRootTabbarViewController().viewControllers
                if currentViewControllerStack.count > 2 {
                    currentViewControllerStack.removeSubrange(1...currentViewControllerStack.count - 2)
                    UIViewController().getRootTabbarViewController().viewControllers = currentViewControllerStack
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar(isHide: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideNavigationBar(isHide: false)
    }

    override func localizedString() {
        willReturnLabel.text = "activity_buy_prob_complete_willreturnsoon".Localizable()
        let pinTitle = "activity_lockscreen_complete_pincreation".Localizable()
        let complete = "activity_lockscreen_complete_label".Localizable()
        let register = "activity_signup_title".Localizable()
        switch completeType {
        case .signUp:
            completeTitle.text = String(format: complete, register)
        case .changePassword:
            completeTitle.text = "forgot_password_success".Localizable()
        case .pinSetting:
            completeTitle.text = String(format: complete, pinTitle)
        }
    }
}

extension SignUpCompleteViewController: PresenterToViewSignUpCompleteProtocol{
    // TODO: Implement View Output Methods
}
