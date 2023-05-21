//
//  KycUpdateInforDateOfBirthView.swift
//  Probit
//
//  Created by Bradley Hoang on 11/11/2022.
//

import UIKit

protocol KycUpdateInforDateOfBirthViewDelegate: AnyObject {
    func kycUpdateInforDateOfBirthTap()
}

final class KycUpdateInforDateOfBirthView: BaseView {
    
    // MARK: - IBOutlet
    @IBOutlet weak var idInforTextField: InLineTextField!
    @IBOutlet private weak var dateOfBirthTitleLabel: UILabel!
    @IBOutlet private weak var dateOfBirthContainerView: UIView!
    @IBOutlet private weak var dateOfBirthLabel: UILabel!
    @IBOutlet private weak var dateOfBirthErrorLabel: UILabel!
    
    // MARK: - Public Variable
    weak var delegate: KycUpdateInforDateOfBirthViewDelegate?
    
    // MARK: - Lifecycle
    override func setupUI() {
        idInforTextField.inputTextField.font = UIFont(name: "SFPro-Regular", size: 16)!
        idInforTextField.backgroundTextViewColor = UIColor.color_f5f5f5_2a2a2a
        idInforTextField.isEnabled = false
        setupCalendarView()
    }
    
    override func localizedString() {
        idInforTextField.title = "globalkyc_editinfo_ocrinfo_title".Localizable()
        dateOfBirthTitleLabel.text = String(format: "globalkyc_editinfo_userinputfield_title".Localizable(), "globalkyc_personalinformation_dob".Localizable().lowercased())
        dateOfBirthLabel.text = "globalkyc_personalinformation_dob_hint".Localizable()
        dateOfBirthErrorLabel.text = "globalkyc_personalinformation_underagewarn".Localizable()
    }
    
    func updateData(checkData: CheckDataModel) {
        idInforTextField.inputTextField.text = checkData.ocrData?.birthday
        if let birthday = checkData.inputData?.birthday,
           !birthday.isEmpty {
            updateDateOfBirthLabel(birthday)
        }
    }
}

// MARK: - Public
extension KycUpdateInforDateOfBirthView {
    func setupDarkMode() {
        idInforTextField.updateBorderStatus()
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

// MARK: - Private
private extension KycUpdateInforDateOfBirthView {
    func setupCalendarView() {
        dateOfBirthContainerView.addTapGesture {
            self.delegate?.kycUpdateInforDateOfBirthTap()
        }
    }
}
