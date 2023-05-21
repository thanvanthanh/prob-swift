
import UIKit

class WithdrawAddressViewController: BaseViewController {
    
    @IBOutlet weak var destinationView: UIView!
    @IBOutlet weak var receivedAmountLabel: UILabel!
    @IBOutlet weak var receivedAmountValueLabel: UILabel!
    @IBOutlet weak var noInputTitle: UILabel!
    @IBOutlet weak var destinationTagTitleLabel: UILabel!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var scanButton: HighlightButon!
    @IBOutlet weak var addressTextField: StyleTextField!
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var allowInputButton: UIButton!
    @IBOutlet weak var stepView: WithdrawStepView!
    @IBOutlet weak var nextButton: StyleButton!
    @IBOutlet weak var usdValue: UILabel!
    @IBOutlet weak var cautionsView: CautionsView!
    @IBOutlet weak var containerDestinationView: UIView!
    
    @IBOutlet weak var addressErrorLabel: UILabel!
    // MARK: - Properties
    var presenter: ViewToPresenterWithdrawAddressProtocol?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        hideKeyboardWhenTappedAround()
        nextButton.setEnable(isEnable: nextButton.isEnabled)
        
        addressTextField.delegateFC = self
        addressTextField.isCustomColor = true
        
        let currencyId = presenter?.withdrawRequest?.currency?.id ?? ""
        let platform = presenter?.withdrawRequest?.currency?.currency?.platform?.first(where: {$0.id == presenter?.withdrawRequest?.selectedPlatform?.id})
        
        cautionsView.showContract(withdrawConfig: presenter?.withdrawRequest?.withdrawalConfig,
                                  dictionary: presenter?.withdrawRequest?.dictionary)
        

        let title = String(format: "activity_withdrawal_title".Localizable(),currencyId)
        let icon = String(format: CurrencyIconType.crypto.url, presenter?.withdrawRequest?.currency?.id ?? "")
        setupNavigationBar(title: title,
                           icon: icon,
                           titleLeftItem: "common_previous".Localizable())
        let platformFee: WithdrawalFee? = presenter?.withdrawRequest?.networkFee
        let fee = platformFee?.currencyID == presenter?.withdrawRequest?.currency?.id ? (platformFee?.amount ?? "").toDouble() : 0
        
        cautionsView.setupCautionsView(currencyId: currencyId,
                                       platform: platform, feeWithdraw: fee.asString())
        let currentValue = (presenter?.withdrawRequest?.amount ?? "").toDouble()
        let fixRate = presenter?.withdrawRequest?.currency?.fixedRate ?? 1
        let receivedValue = currentValue - fee
        let decimalNumber = [(platformFee?.amount ?? "").getDecimalCount(), (presenter?.withdrawRequest?.amount ?? "").getDecimalCount()].max() ?? 0
        let textUsdValue = isLanguageRightToLeft ? "≈ USDT %@" : "≈ %@ USDT"
        usdValue.text = String(format: textUsdValue, String(format: "%.2f", (receivedValue * fixRate)))
        usdValue.isHidden = currencyId == "USDT"
        scanButton.bgColor = .clear
        scanButton.highlightType = .onlyIcon
        receivedAmountValueLabel.text = String.init(format: "%0.\(decimalNumber)f \(currencyId)", receivedValue)
        containerDestinationView.isHidden = !(presenter?.withdrawRequest?.selectedPlatform?.allowWithdrawalDestinationTag ?? false)
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        addressView.borderColor = UIColor.color_e6e6e6_646464
        destinationView.borderColor = UIColor.color_e6e6e6_646464
    }
    
    override func localizedString() {
        nextButton.setTitle("common_next".Localizable(), for: .normal)
        destinationTagTitleLabel.text = "subaddress_destination_tag".Localizable()
        addressTitleLabel.text = "fragment_withdrawal_withdrawaladdress".Localizable()
        destinationTextField.placeholder = "subaddress_destination_tag".Localizable()
        addressTextField.placeholder = "\("fragment_withdrawal_withdrawaladdress".Localizable()) (\(presenter?.withdrawRequest?.selectedPlatform?.displayName?.name?.localized ?? ""))"
        noInputTitle.text = "fragment_withdrawal_address_novalue".Localizable()
        receivedAmountLabel.text = "fragment_withdrawal_receiveamount".Localizable()
    }
    
    func detectNextStatus() {
        nextButton.setEnable(isEnable: addressErrorLabel.text?.isEmpty ?? true)
    }
    
    func scanQRCode() {
        QRCodeScannerRouter().showScreen(completion: { [weak self] address in
            guard let `self` = self else { return }
            guard let lastAddress = address.components(separatedBy: ":").last else { return }
            guard let firstAddress = lastAddress.components(separatedBy: "@").first else { return }

            self.addressTextField.text = firstAddress
            self.presenter?.withdrawRequest?.updateWithdrawModel(address: firstAddress.asTrimmed, destination_tag: self.destinationTextField.text)
            self.presenter?.validateAddress()
        })
    }
    
    // MARK: - Actions
    @IBAction func allowInputTag(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        destinationTextField.isEnabled = !sender.isSelected
        let backgroundColor = destinationTextField.isEnabled ? .clear : UIColor.color_e6e6e6_2a2a2a
        destinationView.backgroundColor = backgroundColor
        let inputTextColor = sender.isSelected ? UIColor.color_282828_fafafa : UIColor.color_282828_7b7b7b
        noInputTitle.textColor = inputTextColor
    }
    
    @IBAction func scanQRCode(_ sender: UIButton) {
        scanQRCode()
    }
    
    @IBAction func gotoReview(_ sender: Any) {
        presenter?.withdrawRequest?.updateWithdrawModel(address: addressTextField.text?.asTrimmed, destination_tag: destinationTextField.text)
        presenter?.gotoReviewDetailView()
    }
    
    @IBAction func didEndEditing(_ sender: UITextField) {
        presenter?.withdrawRequest?.updateWithdrawModel(address: addressTextField.text?.asTrimmed, destination_tag: destinationTextField.text)
        self.presenter?.validateAddress()
    }
}

extension WithdrawAddressViewController: PresenterToViewWithdrawAddressProtocol{
    func addressInvalid() {
        addressErrorLabel.text = String(format: "fragment_withdrawal_address_errorlabel".Localizable(), "subaddress_destination_tag".Localizable())
        self.detectNextStatus()
    }
    
    func addressValid() {
        addressErrorLabel.text = ""
        self.detectNextStatus()
    }
}

extension WithdrawAddressViewController: StyleTextFieldProtocol {
    func focusTextField() {
        addressView.layer.borderColor = addressTextField.strokeFocusColor.cgColor
    }
    
    func unFocusTextField() {
        addressView.layer.borderColor = addressTextField.strokeColor.cgColor
    }
}
