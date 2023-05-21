//
//  InputPinViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 22/08/2022.
//  
//

import UIKit

class InputPinViewController: BaseViewController {
    
    @IBOutlet weak var inputPinTitle: UILabel!
    @IBOutlet weak var inputPinSubTitle: UILabel!
    @IBOutlet weak var inputPinView: InputPinTextField!
    @IBOutlet weak var confirmButton: StyleButton!
    @IBOutlet weak var bottomConstraintConfirmButton: NSLayoutConstraint!
    @IBOutlet weak var failedCounterMessage: UILabel!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmTitle: UILabel!
    @IBOutlet weak var confirmInputPinView: InputPinTextField!
    
    // MARK: - Properties
    var presenter: ViewToPresenterInputPinProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        [inputPinView, confirmInputPinView].forEach{ $0?.inputTextField.delegate = self }
        biometricsApp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputPinView.inputTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAttributedInputPinSubTitle(countFail: AppConstant.countFailPin.string)
        presenter?.getData()
        addObserverKeyBoard()
        guard let type = presenter?.type else { return }
        forgotButton.isHidden = (type != .login)
        checkDisablePin()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        inputPinView.followTheme()
    }
    
    func biometricsApp() {
        guard AppConstant.isBiometrics != .none, let type = presenter?.type else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            switch type {
            case .login:
                AuthenticationManager.shared.authenticationWithTouchID { result in
                    guard result != .none else { return }
                    self.pop()
                }
            default: break
            }
        }
    }
    
    override func localizedString() {
        inputPinTitle.text = "activity_lockscreen_v2_displayarea_title_inputnewpin".Localizable()
        failedCounterMessage.text = "failed_attempt_counter".Localizable()
        failedCounterMessage.isHidden = !(AppConstant.countFailPin >= 2)
        confirmButton.setTitle("activity_lockscreen_confirm".Localizable(), for: .normal)
        forgotButton.setTitle("activity_lockscreen_forgotpassword".Localizable(), for: .normal)
    }
    
    override func updateLayoutWhenKeyboardChanged(height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.bottomConstraintConfirmButton.constant = height > 0 ? (height + 3) : 20
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        presenter?.validateInputLogin(input: inputPinView,
                                      confirm: confirmInputPinView)
    }
    
    @IBAction func forgotAction(_ sender: Any) {
        presenter?.navigateToLogout(viewController: self)
    }
    
    private func setupAttributedInputPinSubTitle(countFail: String) {
        var digits = "activity_lockscreen_v2_displayarea_subtitle_4to16digits".Localizable()
        let count = " (\(countFail)/30)"
        digits.append(count)
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: digits)
        attributedText.apply(color: UIColor.init(hexString: "7B7B7B"), subString: digits)
        attributedText.apply(font: .primary(size: 14), subString: digits)
        attributedText.apply(color: UIColor.Basic.red, subString: count)
        attributedText.apply(font: .primary(size: 14), subString: count)
        if AppConstant.countFailPin > 0 {
            inputPinSubTitle.attributedText = attributedText
        } else {
            inputPinSubTitle.text = "activity_lockscreen_v2_displayarea_subtitle_4to16digits".Localizable()
        }
    }
}

extension InputPinViewController: PresenterToViewInputPinProtocol{
    // TODO: Implement View Output Methods
    
    func fetchData() {
        confirmButton.setEnable(isEnable: false)
        guard let title = presenter?.title,
              let type = presenter?.type else { return }
        setupNavigationBar(title: title,
                                titleLeftItem: presenter?.leftTitle)
        inputPinTitle.text = presenter?.inputPinTitle
        inputPinView.textFieldType = type
    }
    
    func confirmPin() {
        confirmInputPinView.inputTextField.becomeFirstResponder()
        confirmView.isHidden = false
    }
    
    func setupViewStep(_ hide: Bool) {
        confirmView.isHidden = hide
        confirmTitle.text = presenter?.confirmTitle
    }
    
    func showCounterMessage(_ show: Bool) {
        failedCounterMessage.isHidden = show
    }
    
    func validateButton(_ validate: Bool) {
        confirmButton.setEnable(isEnable: validate)
    }
    
    func validateConfirmPassword(_ validate: Bool) {
        [inputPinView, confirmInputPinView].forEach { $0?.removeText()}
        confirmTitle.textColor = validate ? UIColor.color_282828_fafafa : UIColor.init(hexString: "F25D4E")
    }
    
    func validateInput(_ status: Bool, countFail: String, isEnabled: Bool) {
        inputPinView.isUserInteractionEnabled = !status
        confirmButton.setEnable(isEnable: isEnabled)
        var title = ""
        let wrong = "activity_lockscreen_wrongpasswordtitle".Localizable()
        var digits = "activity_lockscreen_v2_displayarea_subtitle_4to16digits".Localizable()
        
        [inputPinTitle, inputPinSubTitle].forEach { $0?.textColor = status ? UIColor.init(hexString: "F25D4E") : UIColor.color_282828_fafafa }
        let type = presenter?.type
        title = type == .disable ? "activity_lockscreen_checkcurrentpassword".Localizable() : "activity_lockscreen_v2_displayarea_title_inputpin".Localizable()
        inputPinTitle.text = status ? wrong : title
        inputPinView.borderColor = status ? UIColor.Basic.red : UIColor.color_e6e6e6_646464
        inputPinView.placeholder = status ? "" : "dialog_hint_input_emailcode".Localizable()
        
        digits.append(" \(countFail)")
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: digits)
        attributedText.apply(color: UIColor.init(hexString: "7B7B7B"), subString: digits)
        attributedText.apply(font: .primary(size: 14), subString: digits)
        attributedText.apply(color: UIColor.Basic.red, subString: countFail)
        attributedText.apply(font: .primary(size: 14), subString: countFail)
        
        if status {
            inputPinSubTitle.text = countFail
        } else {
            inputPinSubTitle.attributedText = attributedText
        }
    }
}

extension InputPinViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)  else { return true }
        confirmButton.setEnable(isEnable: updatedString.count > 3 && updatedString.count < 17)
        return true
    }
}

extension InputPinViewController {
    private func checkDisablePin() {
        let countFail = "(\(AppConstant.countFailPin)/30)"
        guard let type = presenter?.type,
              type == .login,
              AppConstant.isDisableInputPin else { return }
        
        inputPinView.isUserInteractionEnabled = false
        inputPinView.borderColor = UIColor.Basic.red
        self.inputPinView.placeholder = ""
        inputPinSubTitle.text = "failed_attempt_retryafter".Localizable() + countFail
        inputPinTitle.text = "activity_lockscreen_wrongpasswordtitle".Localizable()
        [inputPinTitle, inputPinSubTitle].forEach { $0?.textColor = UIColor.init(hexString: "F25D4E") }
        
        let dispatchAfter = DispatchTimeInterval.seconds(30)
        DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) { [weak self] in
            guard let self = self else { return }
            self.inputPinView.isUserInteractionEnabled = true
            self.inputPinView.placeholder = "dialog_hint_input_emailcode".Localizable()
            AppConstant.isDisableInputPin = true
            self.inputPinTitle.text = "activity_lockscreen_v2_displayarea_title_inputpin".Localizable()
            
            var digits = "activity_lockscreen_v2_displayarea_subtitle_4to16digits".Localizable()
            digits.append(" \(countFail)")
            let attributedText = NSMutableAttributedString.getAttributedString(fromString: digits)
            attributedText.apply(color: UIColor.init(hexString: "7B7B7B"), subString: digits)
            attributedText.apply(font: .primary(size: 14), subString: digits)
            attributedText.apply(color: UIColor.Basic.red, subString: "\(countFail)")
            attributedText.apply(font: .primary(size: 14), subString: "\(countFail)")
            
            AppConstant.isDisableInputPin = false
            self.inputPinView.inputTextField.becomeFirstResponder()
            self.inputPinView.borderColor = UIColor.color_e6e6e6_646464
            self.inputPinSubTitle.attributedText = attributedText
            self.inputPinTitle.textColor = .color_282828_fafafa
        }
    }
}
