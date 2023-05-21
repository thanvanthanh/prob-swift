//
//  ForgotPasswordVerificationViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 05/09/2022.
//  
//

import UIKit

final class ForgotPasswordVerificationViewController: BaseViewController {
    
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var noticeLabel: UILabel!
    @IBOutlet private weak var codeTextField: InLineTextField!
    @IBOutlet private weak var countDownTimeLabel: UILabel!
    @IBOutlet private weak var nextButton: StyleButton!
    @IBOutlet private weak var spacingBottom: NSLayoutConstraint!
    
    // MARK: - Properties
    var presenter: ViewToPresenterForgotPasswordVerificationProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotifications()
        presenter?.startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addObserverKeyBoard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigationBar(title: "activity_verification_title".Localizable(),
                           titleLeftItem: "login_forgot_password".Localizable())
        setupTextField()
        countDownTimeLabel.text = ForgotPasswordVerificationPresenter.Constant.resendTime.toCountdown
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        codeTextField.updateBorderStatus()
    }
    
    override func localizedString() {
        emailLabel.text = presenter?.email
        nextButton.setTitle("common_next".Localizable(), for: .normal)
        noticeLabel.text = String.init(format: "forgot_password_verification_notice_content".Localizable(),
                                       presenter?.email ?? "")
        codeTextField.title = "activity_verification_title".Localizable()
        codeTextField.placeHolder = "dialog_hint_input_emailcode".Localizable()
    }
    
    override func updateLayoutWhenKeyboardChanged(height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.spacingBottom.constant = height > 0 ? height : 40
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        presenter?.stopTimer()
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - IBAction
private extension ForgotPasswordVerificationViewController {
    @IBAction func nextAction(_ sender: Any) {
        guard codeTextField.getInputText().count >= 6 else {
            setupErrorTextField(codeTextField.getInputText())
            return
        }
        presenter?.checkMailCode(codeTextField.getInputText())
    }
}

// MARK: - Private
private extension ForgotPasswordVerificationViewController {
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActiveAction), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resignActiveAction), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func becomeActiveAction() {
        presenter?.becomeActive()
    }
    
    @objc func resignActiveAction() {
        presenter?.resignActive()
    }
    
    func setupTextField() {
        codeTextField.isHide = true
        codeTextField.textFieldType = .verificationCode
        codeTextField.setKeyboardType(.numberPad)
        codeTextField.setBackgroundColor(color: .clear)
    }
    
    func setupErrorTextField(_ code: String) {
        if code.isEmpty {
            codeTextField.setupTextField(error: "forgot_password_pleaseenter_your_verification_code".Localizable())
        } else {
            codeTextField.setupTextField(error: "expire_code".Localizable())
        }
    }
}

// MARK: - PresenterToView

extension ForgotPasswordVerificationViewController: PresenterToViewForgotPasswordVerificationProtocol {
    func showSessionExpiredPopup() {
        showPopupHelper("dialog_notice".Localizable(),
                        message: "dialog_signup_email_sessiontimeout".Localizable(),
                        warning: nil,
                        acceptTitle: "common_confirm".Localizable(),
                        cancleTitle: nil,
                        acceptAction: { [weak self] in
            guard let self = self else { return }
            self.presenter?.popToPreviousView(from: self)
        }, cancelAction: nil)
    }
    
    func updateResendTime(_ time: Int) {
        countDownTimeLabel.text = time.toCountdown
    }
    
    func showInvalidCodeError() {
        codeTextField.setupTextField(error: "expire_code".Localizable())
    }
}
