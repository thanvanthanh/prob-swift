
import UIKit

class VerifyOTPToWithdrawViewController: BaseViewController {
    
    @IBOutlet weak var otpTitle: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var verifyButton: StyleButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var bottomButtonConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    var presenter: ViewToPresenterVerifyOTPToWithdrawProtocol?
    private let otpStackView = OTPStackView()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addObserverKeyBoard()
        otpStackView.selectedFirstResponder()
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
                                titleLeftItem: "common_previous".Localizable())
        addRightBarItem(imageName: "", imageTouch: "", title: "       ")
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
        if numberCode.isEmpty {
            setErrorOTPField(error: ServiceError.init(issueCode: IssueCode.EMPTY_CODE))
            return
        }
        presenter?.validateCode(code: numberCode)
    }
    
    override func updateLayoutWhenKeyboardChanged(height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.bottomButtonConstraint.constant = height > 0 ? height : 34
            self.view.layoutIfNeeded()
        }
    }
}

extension VerifyOTPToWithdrawViewController: PresenterToViewVerifyOTPToWithdrawProtocol {
    func popToRootView() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // TODO: Implement View Output Methods
    func navigateToMailVerification() {
        dismiss(animated: true)
    }
    
    func otpInvalid(error: ServiceError) {
        setErrorOTPField(error: error)
    }
}

extension VerifyOTPToWithdrawViewController: OTPDelegate {
    func finishedFillingOTP() {
        verifyAction(UIButton())
    }
    
    func didChangeValidity(isValid: Bool) {
        // verifyButton.isUserInteractionEnabled = !isValid
    }
    
    func validationIsSuccessful() {
        setErrorOTPField(error: nil)
    }
}
