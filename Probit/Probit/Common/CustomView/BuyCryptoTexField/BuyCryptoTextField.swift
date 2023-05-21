//
//  BuyCryptoTextField.swift
//  Probit
//
//  Created by Thân Văn Thanh on 23/09/2022.
//

import UIKit

enum BuyCryptoTextFieldType {
    case spend
    case receive
}

@IBDesignable class BuyCryptoTextField: BaseView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconImage: UIImageView!
    @IBOutlet private weak var cryptoName: UILabel!
    @IBOutlet weak var selectCryptoButton: UIButton!
    @IBOutlet weak var inputTextField: RTLTextField!
    @IBOutlet weak var inputCryptoView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var model: BuyCryptoPriceModel?
    var textFieldType: BuyCryptoTextFieldType = .spend
    private var selectAction: Action?
    
    var needChangeOtherBorder: (() -> Void)?
    var validateInput: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inputTextField.setLeftPaddingPoints(10)
        inputTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @IBInspectable var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    @IBInspectable var name: String? {
        get {
            return cryptoName.text
        }
        set {
            cryptoName.text = newValue
        }
    }
    
    @IBInspectable var placeholderColor: UIColor? {
        get {
            return inputTextField.placeHolderColor
        }
        set {
            inputTextField.placeHolderColor = newValue
        }
    }
    // 4: numberPad
    // 8: decimalPad
    @IBInspectable var keyboard: Int{
        get{
            return self.inputTextField.keyboardType.rawValue
        }
        set(keyboardIndex){
            self.inputTextField.keyboardType = UIKeyboardType.init(rawValue: keyboardIndex)!

        }
    }
    
    @IBInspectable var placeholder: String? {
        get {
            return inputTextField.placeholder
        }
        set {
            inputTextField.placeholder = newValue
        }
    }
    
    @IBInspectable var setInputText: String? {
        get {
            return inputTextField.text
        }
        set {
            inputTextField.text = newValue
        }
    }
    
    func didAction(action: Action?) {
        self.selectAction = action
    }
    
    @IBAction func selectedAction(_ sender: Any) {
        self.selectAction?()
    }
    
    // MARK: Export view info
    func setupRightToLeft(_ isRTL: Bool) {
        if isRTL {
            inputTextField.setLeftPaddingPoints(10)
        }
    }
    
    func getInputText() -> String {
        return inputTextField.text.value.asTrimmed
    }
    
    func getTextLabel() -> String {
        return cryptoName.text.value
    }
    
    func getErrorMessage() -> String {
        return errorLabel.text ?? ""
    }
    
    @objc func textFieldDidChange() {
        validateInputText()
    }
    
    @IBAction func didEndEditingTextField(_ sender: Any) {
        [inputCryptoView, selectCryptoButton].forEach {
            $0?.layer.borderColor = UIColor.color_e6e6e6_646464.cgColor
        }
        if let changeBorder = self.needChangeOtherBorder {
            changeBorder()
        }
    }
    
    @IBAction func didBeginEditingTextField(_ sender: Any) {
        [inputCryptoView, selectCryptoButton].forEach {
            $0?.layer.borderColor = UIColor.color_4231c8_6f6ff7.cgColor
        }
    }
    
    // MARK: Setup TextField
    func setupTextField(title: String = "", error: String = "") {
        if !title.isEmpty {
            titleLabel.text = title
        }
        errorLabel.text = error
        errorLabel.isHidden = error.isEmpty
        if textFieldType == .spend {
            updateBorderStatus()
        }
    }
    
    func setInputText(newText: String) {
        inputTextField.text = newText
    }
    
    func validateInputText() {
        guard let model = model else { return }
        let min = model.data.fiatMinAmount.asDouble()
        let max = model.data.fiatMaxAmount.asDouble()
        
        let inputText = self.getInputText()
        
        var errorMessage = ""
        let invalidMin = String.init(format: "buycrypto_choosepurchaseamount_spendtextfield_warning_checkmin".Localizable(),
                                     "\(min.string.asPrice.replaceCurrency())", cryptoName.text.value)
        let invalidMax = String.init(format: "buycrypto_choosepurchaseamount_spendtextfield_warning_checkmax".Localizable(),
                                     "\(max.string.asPrice.replaceCurrency())", cryptoName.text.value)
        switch self.textFieldType {
        case .spend:
            if (inputText.asDouble() < min && inputText.count > 0) {
                errorMessage = invalidMin
            } else if (inputText.asDouble() > max && inputText.count > 0) {
                errorMessage = invalidMax
            }
        case .receive:
            errorLabel.isHidden = true
        }
        validateInput = errorMessage.isActuallyEmpty
        setupTextField(error: errorMessage)
    }
    
    func inputTextValid() -> Bool {
        return errorLabel.text?.isEmpty ?? false
    }
    
    func setImgageIcons() {
        switch self.textFieldType {
        case .spend:
            iconImage.loadCurrencyImage(WalletCurrency.generator(getTextLabel(), .fiat))
        case .receive:
            iconImage.loadCurrencyImage(WalletCurrency.generator(getTextLabel(), .crypto))
        }
    }
    
    func updateBorderStatus() {
        let isFocus = inputTextField.isEditing
        let errorMessage = errorLabel.text ?? ""
        if isFocus {
            borderColor = (errorMessage.isEmpty) ? UIColor.color_4231c8_6f6ff7 : UIColor.Basic.red
        } else {
            borderColor = (errorMessage.isEmpty) ? UIColor.color_e6e6e6_646464 : UIColor.Basic.red
        }
        [inputCryptoView, selectCryptoButton].forEach { $0?.layer.borderColor = borderColor?.cgColor }
    }
    
    func updateLoadingBorderStatus() {
        borderColor = UIColor.color_dadada_424242
        [inputCryptoView, selectCryptoButton].forEach { $0?.layer.borderColor = borderColor?.cgColor }
    }
    
    func setupDarkMode() {
        if borderColor == UIColor.color_dadada_424242 {
            inputCryptoView.layer.borderColor = borderColor?.cgColor
        }
    }
}
