//
//  ValidateCardViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 16/11/2565 BE.
//  
//

import UIKit
import SnapKit

class ValidateCardViewController: BaseViewController {
    
    @IBOutlet weak var stackContentView: UIStackView!
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func setupUI() {
        setupValidateView()
        setupNavigationBar(title: "globalkyc_title".Localizable(),
                           titleLeftItem: "navigationbar_settings".Localizable())
    }
    
    func setupViewSuccess() {
        stackContentView.removeFullyAllArrangedSubviews()
        let invalidSuccedView = InvalidSuccedCardView(frame: .zero)
        self.stackContentView.addArrangedSubview(invalidSuccedView)
        invalidSuccedView.delegate = self
        invalidSuccedView.updateView()
    }
    
    func setupViewFailed() {
        stackContentView.removeFullyAllArrangedSubviews()
        let invalidfailedView = InvalidFailedCardView(frame: .zero)
        invalidfailedView.delegate = self
        self.stackContentView.addArrangedSubview(invalidfailedView)
        invalidfailedView.updateView()
    }
    
    func setupValidateView() {
        guard let status = presenter?.interactor?.loadingData?.result else { return }
        switch status {
        case .INVALID:
            setupViewFailed()
        case .NEED_CHECK, .NEED_CONFIRM:
            setupViewSuccess()
        default:
            return
        }
    }

    // MARK: - Properties
    var presenter: ViewToPresenterValidateCardProtocol?
    
    func navigateReTakePhoto(stylePhoto: StylePhoto) {
        let destinationVC = self
        let nav = destinationVC
            .getRootTabbarViewController()
        guard let vc = nav.viewControllers.last(where: { $0.isKind(of: TakeAPhotoViewController.self) }) as? TakeAPhotoViewController else {
            TakeAPhotoRouter(stylePhoto: stylePhoto).showScreen()
            return
        }
        if vc.stylePhoto == stylePhoto {
            nav.popToViewController(vc, animated: true)
        } else {
            TakeAPhotoRouter(stylePhoto: stylePhoto).showScreen()
        }
    }
    
    @objc override func tappedLeftBarButton(sender : UIButton) {
        guard let status = presenter?.interactor?.loadingData?.result else { return }
        switch status {
        case .INVALID:
            guard let cardType = presenter?.interactor?.dataOcr?.idType else { return }
            navigateReTakePhoto(stylePhoto: .CARD(cardType: cardType))
        case .NEED_CHECK, .NEED_CONFIRM:
            shopPopupPopToKycIntro()
        default:
            return
        }
    }
    
}

private extension ValidateCardViewController {
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

extension ValidateCardViewController: PresenterToViewValidateCardProtocol{
    func reloadView() {
        setupValidateView()
    }
    
    // TODO: Implement View Output Methods
}

extension ValidateCardViewController: InvalidSuccedCardViewDelegate,
                                      InvalidFailedCardViewDelegate {
    func doUploadDiffirentId() {
        guard let cardType = presenter?.interactor?.dataOcr?.idType else { return }
        navigateReTakePhoto(stylePhoto: .CARD(cardType: cardType))
    }
    
    func doProceedAnyway() {
        presenter?.doProceedAnyway()
    }
    
    var cardType: TypeCardId {
        get {
            return presenter?.interactor?.dataOcr?.idType ?? .PASSPORT
        }
    }
    
    var backImage: String? {
        get {
            return presenter?.interactor?.dataOcr?.idBackImage
        }
    }
    
    var fontImage: String {
        get {
            return presenter?.interactor?.dataOcr?.idImage ?? ""
        }
    }
}
