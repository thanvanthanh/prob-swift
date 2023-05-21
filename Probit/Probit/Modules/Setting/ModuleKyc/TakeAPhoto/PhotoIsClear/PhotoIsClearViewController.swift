//
//  PhotoIsClearViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 08/11/2565 BE.
//  
//

import UIKit

class PhotoIsClearViewController: BaseViewController {
    @IBOutlet weak var isPhotoLabel: UILabel!
    @IBOutlet weak var confirmBtn: StyleButton!
    @IBOutlet weak var retakeBtn: StyleButton!
    @IBOutlet weak var imageBanner: UIImageView!
    @IBOutlet weak var makeSureLabel: UILabel!
    // MARK: - Lifecycle Methods
    @IBOutlet weak var heightTopStackView: NSLayoutConstraint!
    @IBOutlet weak var captureGuide: UIButton!
    @IBOutlet weak var heightImageView: NSLayoutConstraint!
    @IBOutlet weak var marginLeftStackView: NSLayoutConstraint!
    @IBOutlet weak var marginRightStack: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    override func localizedString() {
        isPhotoLabel.text = "globalkyc_capturereview_confirmcaptured_title".Localizable()
        retakeBtn.setTitle("globalkyc_capturereview_retake".Localizable(), for: .normal)
        guard let stylePhoto = presenter?.interactor?.stylePhoto else { return }
        switch stylePhoto {
        case .FACE:
            confirmBtn.setTitle("common_confirm".Localizable(), for: .normal)
            makeSureLabel.text = "globalkyc_capturereview_confirmcaptured_subtitle_selfie".Localizable()
        case .CARD:
            confirmBtn.setTitle("globalkyc_capturereview_use".Localizable(), for: .normal)
            makeSureLabel.text = "globalkyc_capturereview_confirmcaptured_subtitle".Localizable()
            let text =  "globalkyc_capturereview_showguide".Localizable()
            let attributedText = NSMutableAttributedString.getAttributedString(fromString:text)
            attributedText.apply(font: UIFont.primary(size: 16), subString: text)
            attributedText.apply(color: UIColor.color_4231c8_6f6ff7, subString: text)
            attributedText.underLine(subString: text)
            captureGuide.setAttributedTitle(attributedText, for: .normal)
        }
    }
    
    override func setupUI() {
        setupNavigationBar(title: "globalkyc_title".Localizable(),
                           titleLeftItem: "navigationbar_settings".Localizable())
        retakeBtn.style = .style_2
        guard let stylePhoto = presenter?.interactor?.stylePhoto else { return }
        heightImageView.constant = stylePhoto.imageHeigt
        switch stylePhoto {
        case .FACE:
            captureGuide.isHidden = true
            heightTopStackView.constant = 35.0
            marginRightStack.constant = 32.0
            marginLeftStackView.constant = 32.0
        case .CARD:
            captureGuide.isHidden = false
            heightTopStackView.constant = 76.0
            marginRightStack.constant = 16.0
            marginLeftStackView.constant = 16.0
        }
    }
    
    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        makeSureLabel.textAlignment = isRTL ? .right : .left
    }

    // MARK: - Properties
    var presenter: ViewToPresenterPhotoIsClearProtocol?
    
    
    @IBAction func doRetakePhoto(_ sender: Any) {
        self.presenter?.reTakePhoto()
    }
    @IBAction func doConfirm(_ sender: Any) {
        guard let stylePhoto = presenter?.interactor?.stylePhoto else { return }
        switch stylePhoto {
        case .FACE:
            SelectTypeIdPhotoRouter().showScreen()
        case .CARD(let cardType):
            switch cardType {
            case .ID_CARD_FONT_SIDE:
                TakeAPhotoRouter(stylePhoto: .CARD(cardType: .ID_CARD_BACK_SIDE)).showScreen()
            case .DRIVING_FONT_LICENSE:
                TakeAPhotoRouter(stylePhoto: .CARD(cardType: .DRIVING_BACK_LICENSE)).showScreen()
            default:
                self.presenter?.nextStep()
            }
        }
    }
    
    @IBAction func doShowCapture(_ sender: Any) {
        guard let stylePhoto = presenter?.interactor?.stylePhoto else { return }
        switch stylePhoto {
        case .FACE:
            return
        case .CARD(let cardType):
            let title = String(format: "globalkyc_infocapturedocument_uploaddirection_id_front".Localizable(), cardType.title)
            let mes = String(format: "globalkyc_infocapturedocument_uploaddirection_id_details".Localizable(), title)
            let guideView = GuideView()
            guideView.showGuideVC(title: title,
                                  message: mes,
                                  image: cardType.image,
                                  titleButton: "common_confirm".Localizable(),
                                  onNextAction: {
                guideView.removeToWindow()
            })
        }
    }
    
    @objc override func tappedLeftBarButton(sender : UIButton) {
        self.presenter?.reTakePhoto()
    }
    
}

extension PhotoIsClearViewController: PresenterToViewPhotoIsClearProtocol{
    func reloadView() {
        guard let stylePhoto = presenter?.interactor?.stylePhoto else { return }
        if let link = presenter?.interactor?.dataKyc[stylePhoto.nameSever],
           let url = URL(string: link) {
            imageBanner.load(url: url)
        }
    }
    // TODO: Implement View Output Methods
}

private extension PhotoIsClearViewController {
    
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
