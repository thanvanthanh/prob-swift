//
//  UploadGovermentViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 09/11/2565 BE.
//  
//

import UIKit

class UploadGovermentViewController: BaseViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var headShotLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imageBanner: UIImageView!
    @IBOutlet weak var nextBtn: StyleButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

    // MARK: - Properties
    var presenter: ViewToPresenterUploadGovermentProtocol?
    override func setupUI() {
        setupNavigationBar(title: "globalkyc_title".Localizable(),
                                titleLeftItem: "navigationbar_settings".Localizable())
        if let pageType = presenter?.interactor?.pageType {
            progressBar.progress = pageType.progressValue
        }
    }
    
    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        nameLabel.textAlignment = isRTL ? .right : .left
        dateLabel.textAlignment = isRTL ? .right : .left
        headShotLabel.textAlignment = isRTL ? .right : .left
        allLabel.textAlignment = isRTL ? .right : .left
    }
    
    override func localizedString() {
        titleLabel.text = ""
        messageLabel.text = "kyc_capture_document_guide_clearly_visible".Localizable()
        dateLabel.text = "kyc_capture_document_guide_dob".Localizable()
        nameLabel.text = "kyc_capture_document_guide_name".Localizable()
        headShotLabel.text = "kyc_capture_document_guide_headshot_front".Localizable()
        allLabel.text = "kyc_capture_document_guide_corner".Localizable()
        nextBtn.setTitle("common_next".Localizable(), for: .normal)
    }
    
    @IBAction func doNext(_ sender: Any) {
        guard let stylePhoto = presenter?.interactor?.stylePhoto else { return }
        TakeAPhotoRouter(stylePhoto: stylePhoto).showScreen()
    }
    
    @objc override func tappedLeftBarButton(sender : UIButton) {
        self.navigationController?.popToViewController(ofClass: SelectTypeIdPhotoViewController.self) { isNavigated in
            if isNavigated { return }
            SelectTypeIdPhotoRouter().showScreen()
        }
    }
}
private extension UploadGovermentViewController {
    
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

extension UploadGovermentViewController: PresenterToViewUploadGovermentProtocol {

    func reloadView() {
        guard let stylePhoto = presenter?.interactor?.stylePhoto else { return }
        switch stylePhoto {
        case .CARD(let cardType):
            let title = String(format: "globalkyc_infocapturedocument_uploaddirection_id_front".Localizable(), cardType.title)
            titleLabel.text = title
            imageBanner.image = cardType.image
        default:
            return
        }
    }
}
