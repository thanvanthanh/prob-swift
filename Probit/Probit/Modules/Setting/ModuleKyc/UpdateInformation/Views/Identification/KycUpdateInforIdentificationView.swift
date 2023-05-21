//
//  KycUpdateInforIdentificationView.swift
//  Probit
//
//  Created by Bradley Hoang on 10/11/2022.
//

import UIKit

final class KycUpdateInforIdentificationView: BaseView {
    // MARK: - IBOutlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var firstWarningLabel: UILabel!
    @IBOutlet private weak var secondWarningLabel: UILabel!
    @IBOutlet weak var fontImage: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    
    // MARK: - Lifecycle
    override func localizedString() {
        titleLabel.text = "globalkyc_editinfo_title".Localizable()
        firstWarningLabel.text = "globalkyc_personalinformation_guide1".Localizable()
        secondWarningLabel.text = "globalkyc_personalinformation_guide2".Localizable()
    }
    
    func updateData(checkData: CheckDataModel) {
        if let idImage = checkData.idImage,
           let url = URL(string: idImage){
            self.fontImage.load(url: url)
            fontImage.isHidden = false
        } else {
            fontImage.isHidden = true
        }
        
        if let idBackImage = checkData.idBackImage,
           let url = URL(string: idBackImage){
            backImage.load(url: url)
            backImage.isHidden = false
        } else {
            backImage.isHidden = true
        }
    }
}
