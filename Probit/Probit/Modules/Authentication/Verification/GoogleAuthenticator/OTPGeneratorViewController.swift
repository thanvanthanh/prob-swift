//
//  OTPGeneratorViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 06/09/2022.
//  
//

import UIKit

class OTPGeneratorViewController: BaseViewController {
    
    @IBOutlet weak var otpTitle: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var verifyButton: StyleButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var bottomButtonConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    var presenter: ViewToPresenterOTPGeneratorProtocol?
    private let otpStackView = OTPStackView()
    var delegate: LoginViewControllerDelegate?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
//        tapGesture.cancelsTouchesInView = isCancelTouchInView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addObserverKeyBoard()
        otpStackView.selectedFirstResponder()
//        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setupUI() {
        super.setupUI()
        otpView.addSubview(otpStackView)
        otpStackView.delegate = self
        setErrorOTPField(error: nil)
        
        NSLayoutConstraint.activate([
            otpStackView.topAnchor.constraint(equalTo: otpView.topAnchor, constant: 0),
            otpStackView.bottomAnchor.constraint(equalTo: otpView.bottomAnchor, constant: 0),
            otpStackView.leadingAnchor.constraint(equalTo: otpView.leadingAnchor, constant: 0),
            otpStackView.trailingAnchor.constraint(equalTo: otpView.trailingAnchor, constant: 0)
        ])
        setupNavigationBar(title: "activity_tfa_title".Localizable(),
                                titleLeftItem: "common_login".Localizable())
        if self.navigationController?.viewControllers.contains(where: {$0.className == LoginViewController.className}) != nil {
            addRightBarItem(imageName: "", imageTouch: "", title: "       ")
        } else {
            addRightBarItem(imageName: "", imageTouch: "", title: "common_login".Localizable())
        }
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        otpStackView.setAllFieldColor(color: errorLabel.isHidden ? UIColor.color_e6e6e6_424242 : UIColor.Basic.red)
    }
    
    func setErrorOTPField(error: ServiceError?) {
        errorLabel.isHidden = error == nil
        errorLabel.text = error?.issueCode.message
        otpStackView.setAllFieldColor(color: error == nil ? UIColor.color_e6e6e6_424242 : UIColor.Basic.red)
    }
    
    override func localizedString() {
        otpTitle.text = "activity_tfatotp_methodname".Localizable()
        contentLabel.text = "login_dialog_otp_content".Localizable()
        verifyButton.setTitle("dialog_verify".Localizable(), for: .normal)
    }
    
    @IBAction func verifyAction(_ sender: Any) {
        view.endEditing(true)
        let numberCode = otpStackView.getOTP()
        presenter?.login(totp: numberCode)
    }
    
    override func tappedLeftBarButton(sender: UIButton) {
        presenter?.navigateToLogin()
    }
    
    override func tappedRightBarButton(sender: UIButton) {
        if self.navigationController?.viewControllers.contains(where: {$0.className == LoginViewController.className}) != nil || presenter?.type == .withdraw {
            return
        }
        LoginRouter().showScreen()
    }
    
    override func updateLayoutWhenKeyboardChanged(height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.bottomButtonConstraint.constant = height > 0 ? height : 10
            self.view.layoutIfNeeded()
        }
    }
}

extension OTPGeneratorViewController: PresenterToViewOTPGeneratorProtocol{
    // TODO: Implement View Output Methods
    func navigateToHome() {
        handleLoginFlow()
    }
    
    func otpInvalid(error: ServiceError) {
        setErrorOTPField(error: error)
    }
}

extension OTPGeneratorViewController: OTPDelegate {
    func finishedFillingOTP() {
        let numberCode = otpStackView.getOTP()
        presenter?.login(totp: numberCode)
    }
    
    func didChangeValidity(isValid: Bool) {
        // verifyButton.isUserInteractionEnabled = !isValid
    }
    
    func validationIsSuccessful() {
        setErrorOTPField(error: nil)
    }
}
