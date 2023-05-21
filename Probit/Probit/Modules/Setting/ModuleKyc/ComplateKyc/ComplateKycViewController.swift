//
//  ComplateKycViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 16/11/2565 BE.
//

import UIKit

class ComplateKycViewController: BaseViewController {

    @IBOutlet weak var iconBanner: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var okButton: StyleButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        setupNavigationBar(title: "globalkyc_title".Localizable(),
                           titleLeftItem: "navigationbar_settings".Localizable())
    }
    
    override func localizedString() {
        descriptionLabel.text = "globalkyc_landing_prepareids".Localizable()
        titleLabel.text = String(format: "globalkyc_verificationrequestcomplete_title".Localizable(), "globalkyc_step2".Localizable())
        okButton.setTitle("dialog_ok".Localizable(), for: .normal)
    }
    
    @IBAction func doOk(_ sender: Any) {
        self.navigationController?.popToViewController(ofClass: SettingViewController.self)
    }
    
    
    @objc override func tappedLeftBarButton(sender : UIButton) {
        shopPopupPopToKycIntro()
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
