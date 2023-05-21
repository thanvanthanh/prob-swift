//
//  AppLockViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 27/09/2022.
//  
//

import UIKit

class AppLockViewController: BaseViewController {
    
    @IBOutlet weak var enableAppLockLabel: UILabel!
    @IBOutlet weak var enableAppLockHintLabel: UILabel!
    @IBOutlet weak var appLockSwitch: UISwitch!
    
    @IBOutlet weak var biometricsStack: UIStackView!
    @IBOutlet weak var biometricsLabel: UILabel!
    @IBOutlet weak var biometricsSwitch: UISwitch!
    @IBOutlet weak var biometricsHintLabel: UILabel!
    
    @IBOutlet weak var changePinView: UIView!
    @IBOutlet weak var changePinLabel: UILabel!
    @IBOutlet weak var changePinHinLabel: UILabel!
    // MARK: - Properties
    var presenter: ViewToPresenterAppLockProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigationBar(title: "activity_security_v2_titlebar".Localizable(),
                                titleLeftItem: "navigationbar_settings".Localizable())
        appLockSwitch.semanticContentAttribute = .forceLeftToRight
        biometricsSwitch.semanticContentAttribute = .forceLeftToRight

    }
    
    override func localizedString() {
        enableAppLockLabel.text = "fragment_applocksettings_enableapplock".Localizable()
        enableAppLockHintLabel.text = "fragment_applocksettings_enableapplock_hint".Localizable()
        let canAuthenticateByFaceID = AuthenticationManager.shared.canAuthenticateByFaceID()
        if canAuthenticateByFaceID {
            biometricsLabel.text = "use_face_to_unlock".Localizable()
            biometricsHintLabel.text = "use_device_s_face_sensor_to_unlock".Localizable()
        } else {
            biometricsLabel.text = "use_fingerprint_to_unlock".Localizable()
            biometricsHintLabel.text = "use_device_s_fingerprint_sensor_to_unlock".Localizable()
        }
        changePinLabel.text = "fragment_applocksettings_changepin".Localizable()
        changePinHinLabel.text = "fragment_applocksettings_changepin_hint".Localizable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appLockSwitch.isOn = AppConstant.isAppLock
        [biometricsStack, changePinView].forEach { $0?.isHidden = !appLockSwitch.isOn}
        biometricsSwitch.isOn = AppConstant.isBiometrics != .none
    }
    
    @IBAction func appLockSwitchChange(_ sender: UISwitch) {
        [biometricsStack, changePinView].forEach { $0?.isHidden = !sender.isOn}
        let type: InputPinType = sender.isOn ? .enable : .disable
        presenter?.navigateToInputPin(type: type)
    }
    
    @IBAction func biometricsSwitchChange(_ sender: UISwitch) {
        if sender.isOn {
            AuthenticationManager.shared.authenticationWithTouchID { [weak self] result in
                AppConstant.isBiometrics = result
                self?.biometricsSwitch.isOn = result != .none
                return
            }
        }
        AppConstant.isBiometrics = .none
    }
    
    @IBAction func changePinAction(_ sender: Any) {
        presenter?.navigateToInputPin(type: .change)
    }
}

extension AppLockViewController: PresenterToViewAppLockProtocol{
    // TODO: Implement View Output Methods
}
