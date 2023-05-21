//
//  KycUpdateInforFullNameView.swift
//  Probit
//
//  Created by Bradley Hoang on 11/11/2022.
//

import UIKit

final class KycUpdateInforFullNameView: BaseView {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var idInforTextField: InLineTextField!
    @IBOutlet weak var confirmIdInforTextField: InLineTextField!
    
    // MARK: - Lifecycle
    override func setupUI() {
        idInforTextField.inputTextField.font = UIFont(name: "SFPro-Regular", size: 16)!
        idInforTextField.backgroundTextViewColor = UIColor.color_f5f5f5_2a2a2a
        idInforTextField.isEnabled = false
        
        confirmIdInforTextField.inputTextField.font = UIFont(name: "SFPro-Regular", size: 16)!
        confirmIdInforTextField.textFieldType = .name
        confirmIdInforTextField.setKeyboardType(.default)
    }
    
    override func localizedString() {
        fullNameLabel.text = "globalkyc_personalinformation_name".Localizable()
        idInforTextField.title = "globalkyc_editinfo_ocrinfo_title".Localizable()
        confirmIdInforTextField.title = String(format: "globalkyc_editinfo_userinputfield_title".Localizable(), "globalkyc_personalinformation_name".Localizable().lowercased())
    }
    
    func updateData(checkData: CheckDataModel) {
        idInforTextField.inputTextField.text = checkData.ocrData?.name
        confirmIdInforTextField.setInputText(newText: checkData.inputData?.name ?? "")
    }
}

// MARK: - Public
extension KycUpdateInforFullNameView {
    func setupDarkMode() {
        idInforTextField.updateBorderStatus()
        confirmIdInforTextField.updateBorderStatus()
    }
}
