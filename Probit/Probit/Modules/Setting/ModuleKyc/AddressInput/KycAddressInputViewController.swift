//
//  KycAddressInputViewController.swift
//  Probit
//
//  Created by Bradley Hoang on 09/11/2022.
//  
//

import UIKit

final class KycAddressInputViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var streetAddressTextField: InLineTextField!
    @IBOutlet private weak var cityAddressTextField: InLineTextField!
    @IBOutlet private weak var postalCodeTextField: InLineTextField!
    @IBOutlet private weak var progressBar: UIProgressView!
    @IBOutlet weak var nextButton: StyleButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Properties
    var presenter: ViewToPresenterKycAddressInputProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        scrollView.hideKeyboard()
    }
    
    override func setupUI() {
        super.setupUI()
        self.nextButton.setEnable(isEnable: false)
        setupNavigationBar(title: "globalkyc_title".Localizable(),
                           titleLeftItem: "navigationbar_settings".Localizable())
        setupTextField()
        if let pageType = presenter?.interactor?.pageType {
            progressBar.progress = pageType.progressValue
        }
    }
    
    override func localizedString() {
        titleLabel.text = "globalkyc_address_title".Localizable()
        streetAddressTextField.title = "globalkyc_address_streetaddress".Localizable()
        streetAddressTextField.placeHolder = "globalkyc_address_streetaddress_hint".Localizable()
        cityAddressTextField.title = "globalkyc_address_citystate".Localizable()
        cityAddressTextField.placeHolder = "globalkyc_address_citystate_hint".Localizable()
        postalCodeTextField.title = "globalkyc_address_postalcode".Localizable()
        postalCodeTextField.placeHolder = "globalkyc_address_postalcode_hint".Localizable()
        nextButton.setTitle("common_next".Localizable(), for: .normal)
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        streetAddressTextField.updateBorderStatus()
        cityAddressTextField.updateBorderStatus()
        postalCodeTextField.updateBorderStatus()
    }
    
    @objc override func tappedLeftBarButton(sender : UIButton) {
        self.navigationController?.popToViewController(ofClass: KycPersonalInfoInputViewController.self) { isNavigated in
            if isNavigated { return }
            KycPersonalInfoInputRouter().showScreen()
        }
    }
}

// MARK: - IBAction
private extension KycAddressInputViewController {
    @IBAction func nextAction(_ sender: Any) {
        let city = cityAddressTextField.getInputText()
        let postal = postalCodeTextField.getInputText()
        let address = streetAddressTextField.getInputText()
        guard !city.isEmpty, !postal.isEmpty, !address.isEmpty else { return }
        presenter?.updatePersionalDataKyc(["city": city,
                                           "postal": postal,
                                           "address": address])
    }
}

// MARK: - Private
private extension KycAddressInputViewController {
    func setupTextField() {
        streetAddressTextField.inputTextField.font = UIFont(name: "SFPro-Regular", size: 16)!
        streetAddressTextField.isHide = true
        streetAddressTextField.textFieldType = .name
        streetAddressTextField.setKeyboardType(.default)
        streetAddressTextField.inputTextField.addTarget(self,
                                                   action: #selector(inputTextFieldChanged),
                                                   for: .editingChanged)
        
        cityAddressTextField.inputTextField.font = UIFont(name: "SFPro-Regular", size: 16)!
        cityAddressTextField.isHide = true
        cityAddressTextField.textFieldType = .name
        cityAddressTextField.setKeyboardType(.default)
        cityAddressTextField.inputTextField.addTarget(self,
                                                   action: #selector(inputTextFieldChanged),
                                                   for: .editingChanged)
        
        postalCodeTextField.inputTextField.font = UIFont(name: "SFPro-Regular", size: 16)!
        postalCodeTextField.isHide = true
        postalCodeTextField.textFieldType = .name
        postalCodeTextField.setKeyboardType(.default)
        postalCodeTextField.inputTextField.addTarget(self,
                                                   action: #selector(inputTextFieldChanged),
                                                   for: .editingChanged)
    }
    
    @objc func inputTextFieldChanged(_ sender: Any) {
        presenter?.handleNextButtonState(streetAddressTextField.getInputText(), city: cityAddressTextField.getInputText(), postalCode: postalCodeTextField.getInputText())
    }
}

// MARK: - PresenterToView
extension KycAddressInputViewController: PresenterToViewKycAddressInputProtocol {
    // TODO: Implement View Output Methods
    func updateViewPersonal() {
        guard let personalInfor = presenter?.interactor?.personalInfor else { return }
        if let city = personalInfor["city"] {
            cityAddressTextField.setInputText(newText: city)
        }
        if let postal = personalInfor["postal"] {
            postalCodeTextField.setInputText(newText: postal)
        }

        if let address = personalInfor["address"] {
            streetAddressTextField.setInputText(newText: address)
        }
        presenter?.handleNextButtonState(streetAddressTextField.getInputText(), city: cityAddressTextField.getInputText(), postalCode: postalCodeTextField.getInputText())
    }
    
    func enableNextButton(_ enable: Bool) {
        self.nextButton.setEnable(isEnable: enable)
    }
}

private extension KycAddressInputViewController {
    
    func shopPopupPopToKycIntro() {
        showPopupHelper("globalkyc_activity_closedialog_title".Localizable(),
                        message: "globalkyc_activity_closedialog_content".Localizable(),
                        warning: nil,
                        acceptTitle: "globalkyc_activity_closedialog_confirmbutton".Localizable(),
                        cancleTitle: "globalkyc_activity_closedialog_closebutton".Localizable(),
                        acceptAction: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popToViewController(ofClass: SettingViewController.self)
        }, cancelAction: nil)
    }
}
