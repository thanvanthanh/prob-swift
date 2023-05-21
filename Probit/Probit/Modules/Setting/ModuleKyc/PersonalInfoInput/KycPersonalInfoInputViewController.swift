//
//  KycPersonalInfoInputViewController.swift
//  Probit
//
//  Created by Bradley Hoang on 08/11/2022.
//  
//

import UIKit

final class KycPersonalInfoInputViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var ensureLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private weak var fullnameTextField: InLineTextField!
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var maleRadioBoxImageView: UIImageView!
    @IBOutlet private weak var maleLabel: UILabel!
    @IBOutlet private weak var femaleRadioBoxImageView: UIImageView!
    @IBOutlet private weak var femaleLabel: UILabel!
    @IBOutlet private weak var dateOfBirthTitleLabel: UILabel!
    @IBOutlet private weak var dateOfBirthContainerView: UIView!
    @IBOutlet private weak var dateOfBirthLabel: UILabel!
    @IBOutlet private weak var dateOfBirthErrorLabel: UILabel!
    @IBOutlet private weak var progressBar: UIProgressView!
    @IBOutlet private weak var nextButton: StyleButton!
    @IBOutlet private weak var nextButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    var presenter: ViewToPresenterKycPersonalInfoInputProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        addObserverKeyBoard()
        scrollView.hideKeyboard()
    }
    
    override func setupUI() {
        super.setupUI()
        nextButton.setEnable(isEnable: false)
        setupNavigationBar(title: "globalkyc_title".Localizable(),
                           titleLeftItem: "navigationbar_settings".Localizable())
        setupTextField()
        setupCalendarView()
        if let pageType = presenter?.interactor?.pageType {
            progressBar.progress = pageType.progressValue
        }
    }
    
    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        fullnameTextField.setupRightToLeft(isRTL)
    }
    
    override func localizedString() {
        titleLabel.text = "globalkyc_personalinformation_title".Localizable()
        ensureLabel.text = "globalkyc_personalinformation_guide1".Localizable()
        fullnameTextField.title = "globalkyc_personalinformation_name".Localizable()
        fullnameTextField.placeHolder = "globalkyc_personalinformation_name_hint".Localizable()
        genderLabel.text = "globalkyc_personalinformation_gender".Localizable()
        maleLabel.text = "globalkyc_gender_male".Localizable()
        femaleLabel.text = "globalkyc_gender_female".Localizable()
        dateOfBirthTitleLabel.text = "globalkyc_personalinformation_dob".Localizable()
        dateOfBirthLabel.text = "globalkyc_personalinformation_dob_hint".Localizable()
        dateOfBirthErrorLabel.text = "globalkyc_personalinformation_underagewarn".Localizable()
        nextButton.setTitle("common_next".Localizable(), for: .normal)
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        fullnameTextField.updateBorderStatus()
        if let isValid = presenter?.isValidDateOfBirth,
           isValid {
            dateOfBirthContainerView.borderColor = UIColor.color_e6e6e6_646464
        } else {
            dateOfBirthContainerView.borderColor = UIColor.Basic.red
        }
    }
    
    override func updateLayoutWhenKeyboardChanged(height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.nextButtonBottomConstraint.constant = height > 0 ? height : 10
            self.view.layoutIfNeeded()
        }
    }
    
    @objc override func tappedLeftBarButton(sender: UIButton) {
        navigationController?.popToViewController(ofClass: KycSelectCountryViewController.self) { isNavigated in
            if isNavigated { return }
            KycSelectCountryRouter().showScreen()
        }
    }
}

// MARK: - IBAction
private extension KycPersonalInfoInputViewController {
    @IBAction func maleSelected(_ sender: Any) {
        presenter?.selectGender(.male)
    }
    
    @IBAction func femaleSelected(_ sender: Any) {
        presenter?.selectGender(.female)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        let name = fullnameTextField.getInputText()
        guard let birthday = presenter?.dateOfBirth?.stringFromDate(format: "yyyy-MM-dd"),
              let gender = presenter?.gender?.rawValue,
              !name.isEmpty else { return }
        presenter?.updatePersionalDataKyc(["name": name,
                                           "gender": gender,
                                           "birthday": birthday])
    }
}

// MARK: - Private
private extension KycPersonalInfoInputViewController {
    func setupCalendarView() {
        dateOfBirthContainerView.addTapGesture {
            let dateOfBirth = self.presenter?.dateOfBirth ?? Date()
            KycCalendarRouter().showScreen(delegate: self,
                                           selectedDate: dateOfBirth)
        }
    }
    
    func setupTextField() {
        fullnameTextField.inputTextField.font = UIFont(name: "SFPro-Regular", size: 16)!
        fullnameTextField.isHide = true
        fullnameTextField.textFieldType = .kycFullName
        fullnameTextField.setKeyboardType(.default)
        fullnameTextField.setBackgroundColor(color: .clear)
        fullnameTextField.inputTextField.addTarget(self,
                                                   action: #selector(inputTextFieldChanged),
                                                   for: .editingChanged)
    }
    
    @objc func inputTextFieldChanged(_ sender: Any) {
        presenter?.changeFullName(fullnameTextField.getInputText())
    }
    
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

// MARK: - PresenterToView
extension KycPersonalInfoInputViewController: PresenterToViewKycPersonalInfoInputProtocol {
    func enableNextButton(_ enable: Bool) {
        nextButton.setEnable(isEnable: enable)
    }
    
    func updateViewPersonal() {
        guard let personalInfor = presenter?.interactor?.personalInfor else { return }
        if let name = personalInfor["name"] {
            fullnameTextField.setInputText(newText: name)
            presenter?.changeFullName(name)
        }
        if let gender = personalInfor["gender"] {
            let genderType = GenderType.initValue(gender)
            presenter?.selectGender(genderType)
            updateSelectedGender(genderType)
        }
        if let birthday = personalInfor["birthday"] {
            let date = birthday.toDate("yyyy-MM-dd")
            presenter?.selectDateOfBirth(date)
        }
    }
    
    func updateSelectedGender(_ gender: GenderType) {
        maleRadioBoxImageView.image = UIImage(named: "ico_kyc_radio_full_uncheck")
        femaleRadioBoxImageView.image = UIImage(named: "ico_kyc_radio_full_uncheck")
        maleRadioBoxImageView.tintColor = UIColor(named: "color_646464")
        femaleRadioBoxImageView.tintColor = UIColor(named: "color_646464")
        
        switch gender {
        case .male:
            maleRadioBoxImageView.image = UIImage(named: "ico_kyc_radio_check")
            maleRadioBoxImageView.tintColor = UIColor(named: "color_4231c8_6f6ff7")
        case .female:
            femaleRadioBoxImageView.image = UIImage(named: "ico_kyc_radio_check")
            femaleRadioBoxImageView.tintColor = UIColor(named: "color_4231c8_6f6ff7")
        }
    }
    
    func updateDateOfBirthLabel(_ dateString: String) {
        dateOfBirthLabel.text = dateString
        dateOfBirthLabel.textColor = UIColor.color_282828_fafafa
    }
    
    func showDateOfBirthError() {
        dateOfBirthErrorLabel.isHidden = false
        dateOfBirthContainerView.borderColor = UIColor.Basic.red
    }
    
    func hideDateOfBirthError() {
        dateOfBirthErrorLabel.isHidden = true
        dateOfBirthContainerView.borderColor = UIColor.color_e6e6e6_646464
    }
}

// MARK: - KycCalendarDelegate
extension KycPersonalInfoInputViewController: KycCalendarDelegate {
    func kycCalendarDidSelectDate(_ date: Date) {
        presenter?.selectDateOfBirth(date)
    }
}
