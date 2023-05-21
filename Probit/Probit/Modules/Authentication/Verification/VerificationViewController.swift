//
//  VerificationViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 22/08/2022.
//  
//

import UIKit


class VerificationViewController: BaseViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var inputVerificationCode: InLineTextField!
    @IBOutlet weak var countDownTimeView: UIView!
    @IBOutlet weak var countDownTimeLabel: UILabel!
    @IBOutlet weak var emailHelpButton: UIButton!
    @IBOutlet weak var verifyButton: StyleButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private var count = 59
    private var timer: Timer?
    private var maxLengthInput = 6
    private var _didInput: Bool = false
    
    var didInputOTP: Bool { return inputVerificationCode.textDidChange }
   
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.hideKeyboard()
        addObserverApplicationState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter?.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addObserverKeyBoard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(VerificationViewController.tapResendEmail))
        countDownTimeLabel.isUserInteractionEnabled = true
        countDownTimeLabel.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.presenter?.viewWillDisappear()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func updateTimeInBackground(time: Int) {
        super.updateTimeInBackground(time: time)
        let newCount = count - time
        self.count = newCount > 0 ? newCount : 0
        updateCountDownTime()
    }
    
    deinit {
        stopTimer()
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterVerificationProtocol?
    
    override func setupUI() {
        super.setupUI()
        var leftTitle = "common_previous"
        leftTitle = presenter?.type == .signUp ? "activity_signup_title" : leftTitle
        leftTitle = presenter?.type == .signIn ? "common_login" : leftTitle
        inputVerificationCode.backgroundTextViewColor = UIColor.color_ffffff_181818
        if presenter?.type == .withdraw,
           let viewcontrollers = self.navigationController?.viewControllers,
           let withdrawalReviewIndex = viewcontrollers.firstIndex(where: { $0.className == WithdrawReviewViewController.className }),
           let titleView = viewcontrollers[withdrawalReviewIndex].navigationItem.titleView as? TitleViewNavigationBar {
            let newViewControllers = Array(viewcontrollers[0...withdrawalReviewIndex])
            self.navigationController?.viewControllers = newViewControllers + [self]
            leftTitle = titleView.title ?? ""
        }
        
        setupNavigationBar(title: "activity_tfa_title".Localizable(),
                                titleLeftItem: leftTitle.Localizable())
        startTimer()
        setupTextField()
        if presenter?.type == .signUp {
            addRightBarItem(imageName: "", imageTouch: "", title: "common_login".Localizable())
        } else {
            addRightBarItem(imageName: "", imageTouch: "", title: "       ")
        }
    }
    
    override func localizedString() {
        emailLabel.text = presenter?.email
        contentLabel.text = "dialog_email_content".Localizable()
        emailHelpButton.setTitle("dialog_email_help".Localizable(), for: .normal)
        emailHelpButton.underline()
        verifyButton.setTitle("dialog_verify".Localizable(), for: .normal)
        inputVerificationCode.placeHolder = "dialog_hint_input_emailcode".Localizable()
    }
    
    func setupTextField() {
        inputVerificationCode.title = nil
        inputVerificationCode.isHide = true
        inputVerificationCode.textFieldType = .verificationCode
        inputVerificationCode.setKeyboardType(.numberPad)
        inputVerificationCode.setBackgroundColor(color: .clear)
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        inputVerificationCode.updateBorderStatus()
        countDownTimeView.borderColor = UIColor.color_e6e6e6_646464
    }
    
    
    @IBAction func verifyAction(_ sender: Any) {
        inputVerificationCode.validateInputText()
        let numberCode = inputVerificationCode.getInputText()
        if numberCode.isEmpty {
            inputVerificationCode.setupTextField(error: "commom_field_can_not_empty".Localizable())
            return
        }
        switch presenter?.type {
        case .signIn:
            presenter?.login(emailCode: numberCode)
        case .signUp:
            presenter?.signupProcess(code: numberCode)
        default:
            presenter?.verifyWithdrawCode(code: numberCode)
        }
    }
    
    @IBAction func emailHelpAction(_ sender: Any) {
        presenter?.navigateToHelpEmail()
    }
    
    @objc func updateCountDownTime() {
        if(count > 0) {
            countDownTimeLabel.text = count.toCountdown
            count -= 1
        } else {
            countDownTimeLabel.text = "dialog_email_resend".Localizable()
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc
    func tapResendEmail(sender: UITapGestureRecognizer) {
        if count != 0 {
            return
        }
        presenter?.signUpResendOtp()
    }
    
    private func startTimer() {
        stopTimer()
        count = presenter?.type == .signUp ? 59 : 599
        countDownTimeLabel.text = (count + 1).toCountdown
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self, selector: #selector(updateCountDownTime),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    override func updateLayoutWhenKeyboardChanged(height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.bottomConstraint.constant = height > 0 ? height : 40
            self.view.layoutIfNeeded()
        }
    }
    
    override func tappedLeftBarButton(sender: UIButton) {
        if presenter?.type == .withdraw {
            self.pop()
            return
        }
        presenter?.popToRootView()
    }
    
    override func tappedRightBarButton(sender: UIButton) {
        if presenter?.type == .signIn || presenter?.type == .withdraw {
            return
        }
        LoginRouter().showScreen()
    }
    
    private func setupErrorTextField() {
        inputVerificationCode.setupTextField(error: "dialog_email_codeinvalid".Localizable())
    }
}

extension VerificationViewController: PresenterToViewVerificationProtocol {
    // TODO: Implement View Output Methods
    func resendOtp() {
        startTimer()
    }
    
    func showAlertExpire(excute: (() -> Void)?) {
        showPopupHelper("dialog_notice".Localizable(),
                        message: "dialog_signup_email_sessiontimeout".Localizable(),
                        warning: nil,
                        acceptTitle: "common_confirm".Localizable(),
                        cancleTitle: nil,
                        touchDismiss: false,
                        acceptAction: excute,
                        cancelAction: nil)

    }

    func sendOTPFail() {
        showPopupHelper("dialog_notice".Localizable(),
                        message: "dialog_signup_email_sessiontimeout".Localizable(),
                        warning: nil,
                        acceptTitle: "common_confirm".Localizable(),
                        cancleTitle: nil,
                        acceptAction: { [weak self] in
            guard let self = self else { return }
            self.presenter?.reLogin()
        }, cancelAction: nil)
    }
    
    func otpInvalid(error: ServiceError) {
        var errorMessage = "expire_code".Localizable()
        switch error.issueCode {
        case .WRONG_CODE:
            if presenter?.type == .signUp {
                errorMessage = "fragment_tfasms_genericfailure".Localizable()
            }
            break
        case .SESSION_EXPIRE:
            break
        case .ALREADY_SIGNED_UP:
            errorMessage = "fragment_signupemailcheckup_alreadysignedup".Localizable()
        default:
            break
        }
        inputVerificationCode.setupTextField(error: errorMessage)
    }
    
    func navigateToHome() {
        handleLoginFlow()
    }
}
