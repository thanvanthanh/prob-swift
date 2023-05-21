//
//  KycUpdateInforGenderView.swift
//  Probit
//
//  Created by Bradley Hoang on 11/11/2022.
//

import UIKit

final class KycUpdateInforGenderView: BaseView {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var idInforTextField: InLineTextField!
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var maleRadioBoxImageView: UIImageView!
    @IBOutlet private weak var maleLabel: UILabel!
    @IBOutlet private weak var femaleRadioBoxImageView: UIImageView!
    @IBOutlet private weak var femaleLabel: UILabel!
    var genderSelected: GenderType = .female {
        didSet {
            updateSelectedGender(genderSelected)
        }
    }
    // MARK: - Lifecycle
    override func setupUI() {
        idInforTextField.inputTextField.font = UIFont(name: "SFPro-Regular", size: 16)!
        idInforTextField.backgroundTextViewColor = UIColor.color_f5f5f5_2a2a2a
        idInforTextField.isEnabled = false
    }
    
    override func localizedString() {
        titleLabel.text = "globalkyc_personalinformation_gender".Localizable()
        idInforTextField.title = "globalkyc_editinfo_ocrinfo_title".Localizable()
        genderLabel.text = "globalkyc_personalinformation_gender".Localizable()
        maleLabel.text = "globalkyc_gender_male".Localizable()
        femaleLabel.text = "globalkyc_gender_female".Localizable()
    }
    
    func updateData(checkData: CheckDataModel) {
        idInforTextField.inputTextField.text = checkData.ocrData?.gender?.firstUppercased
        if let gender = checkData.inputData?.gender, !gender.isEmpty {
            let genderType = GenderType.initValue(gender)
            genderSelected = genderType
        }
    }
}

// MARK: - Public
extension KycUpdateInforGenderView {
    func setupDarkMode() {
        idInforTextField.updateBorderStatus()
    }
}

// MARK: - IBAction
private extension KycUpdateInforGenderView {
    @IBAction func maleSelected(_ sender: Any) {
        genderSelected = .male
    }
    
    @IBAction func femaleSelected(_ sender: Any) {
        genderSelected = .female
    }
}

// MARK: - Private
private extension KycUpdateInforGenderView {
    func updateSelectedGender(_ gender: GenderType) {
        maleRadioBoxImageView.image = UIImage(named: "ico_kyc_radio_uncheck")
        femaleRadioBoxImageView.image = UIImage(named: "ico_kyc_radio_uncheck")
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
}
