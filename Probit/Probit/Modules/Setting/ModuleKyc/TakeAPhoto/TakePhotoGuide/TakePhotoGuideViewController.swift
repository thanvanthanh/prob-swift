//
//  TakePhotoGuideViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 08/11/2565 BE.
//  
//

import UIKit

class TakePhotoGuideViewController: BaseViewController {
    
    @IBOutlet weak var uploadLabel: UILabel!
    @IBOutlet weak var makeSureLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var desLabel1: UILabel!
    @IBOutlet weak var desLabel2: UILabel!
    @IBOutlet weak var desLabel3: UILabel!
    @IBOutlet weak var desLabel4: UILabel!

    @IBOutlet weak var nextBtn: StyleButton!
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func localizedString() {
        makeSureLabel.text = "kyc_selfie_guide_1".Localizable()
        desLabel1.text = "kyc_selfie_guide_2".Localizable()
        desLabel2.text = "kyc_selfie_guide_3".Localizable()
        desLabel3.text = "kyc_selfie_guide_4".Localizable()
        desLabel4.text = "kyc_selfie_guide_5".Localizable()
        uploadLabel.text = "globalkyc_infocapturedocument_uploaddirection_selfie".Localizable()
        nextBtn.setTitle("common_next".Localizable(), for: .normal)
    }
    
    override func setupUI() {
        setupNavigationBar(title: "globalkyc_title".Localizable(),
                                titleLeftItem: "navigationbar_settings".Localizable())
    }

    // MARK: - Properties
    var presenter: ViewToPresenterTakePhotoGuideProtocol?
    
    @IBAction func doNext(_ sender: Any) {
        TakeAPhotoRouter(stylePhoto: .FACE).showScreen()
    }
    
    @objc override func tappedLeftBarButton(sender : UIButton) {
        self.navigationController?.popToViewController(ofClass: KycAddressInputViewController.self) { isNavigated in
            if isNavigated { return }
            KycAddressInputRouter().showScreen()
        }
    }
}

extension TakePhotoGuideViewController: PresenterToViewTakePhotoGuideProtocol{
    // TODO: Implement View Output Methods
}
private extension TakePhotoGuideViewController {
    
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

