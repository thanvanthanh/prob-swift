//
//  WithdrawVerificationViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 01/12/2565 BE.
//  
//

import UIKit
import YubiKit

struct AssertOnKeyAuthenticationResponse {
    let uuid: String
    let requestId: String
    let credentialId: Data
    let authenticatorData: Data
    let clientDataJSON: Data
    let signature: Data
}

struct BeginWebAuthnAuthenticationResponse {
    let uuid: String
    let requestId: String
    let challenge: String
    let rpId: String
    let allowCredentials: [String]
}

enum ConnectionType {
    case nfc
    case accessory
}

class WithdrawVerificationViewController: BaseViewController {
    @IBOutlet weak var verifyButton: StyleButton!
    @IBOutlet weak var desDeviceLabel: UILabel!
    @IBOutlet weak var deviceLabel: UILabel!
    @IBOutlet weak var imgDevice: UIImageView!
    
    var delegate: LoginViewControllerDelegate?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterWithdrawVerificationProtocol?
    
    override func setupUI() {
        setupNavigationBar(title: "tradecompetition_main_requirement_kyc_eligibility_verification".Localizable(),
                           titleLeftItem: "common_previous".Localizable())
    }
    
    // MARK: - YKFManagerDelegate
    var nfcConnection: YKFNFCConnection?
    var session: YKFFIDO2Session?
    var accessoryConnection: YKFAccessoryConnection?
    var connectionCallback: ((_ connection: YKFConnectionProtocol) -> Void)?
    
    var connectionType: ConnectionType? {
        get {
            if nfcConnection != nil {
                return .nfc
            } else if accessoryConnection != nil {
                return .accessory
            } else {
                return nil
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.startConnectYubi()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }
    
    override func localizedString() {
        desDeviceLabel.text = "activity_verification_u2f_connect_u2f_to_device".Localizable()
        deviceLabel.text = "activity_verification_u2f_hardware_key".Localizable()
        verifyButton.setTitle("dialog_verify".Localizable(), for: .normal)
    }
    
    @IBAction func doVerify(_ sender: Any) {
        presenter?.beginVerify()
    }
    
    func navigateToHome() {
        postObservers()
        delegate?.loginVCDismiss()
        handleLoginFlow()
    }
}

extension WithdrawVerificationViewController: PresenterToViewWithdrawVerificationProtocol{
    // TODO: Implement View Output Methods
}

extension WithdrawVerificationViewController {
    func postObservers(){
        NotificationCenter.default.post(name: .loginComplete,
                                        object: nil)
    }
}

