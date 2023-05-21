//
//  KycUpdateInformationViewController.swift
//  Probit
//
//  Created by Bradley Hoang on 10/11/2022.
//  
//

import UIKit

final class KycUpdateInformationViewController: BaseViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var fullNameView: KycUpdateInforFullNameView!
    @IBOutlet private weak var genderView: KycUpdateInforGenderView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private weak var dateOfBirthView: KycUpdateInforDateOfBirthView!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var nextButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardView: KycUpdateInforIdentificationView!
    // MARK: - Properties
    var presenter: ViewToPresenterKycUpdateInformationProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        addObserverKeyBoard()
        scrollView.hideKeyboard()
        dateOfBirthView.delegate = self
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigationBar(title: "globalkyc_title".Localizable(),
                           titleLeftItem: "navigationbar_settings".Localizable())
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        fullNameView.setupDarkMode()
        genderView.setupDarkMode()
    }
    
    override func localizedString() {
        nextButton.setTitle("common_next".Localizable(), for: .normal)
    }
    
    override func updateLayoutWhenKeyboardChanged(height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.nextButtonBottomConstraint.constant = height > 0 ? height : 10
            self.view.layoutIfNeeded()
        }
    }
    
//    @objc override func tappedLeftBarButton(sender : UIButton) {
//        shopPopupPopToKycIntro()
//    }
}

// MARK: - IBAction
private extension KycUpdateInformationViewController {
    @IBAction func nextAction(_ sender: Any) {
        presenter?.updatePersionalDataKyc(["name": fullNameView.confirmIdInforTextField.getInputText(),
                                           "gender": genderView.genderSelected.rawValue,
                                           "birthday": dateOfBirthView.idInforTextField.getInputText()])

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
extension KycUpdateInformationViewController: PresenterToViewKycUpdateInformationProtocol {
    func reloadView() {
        guard let checkData = self.presenter?.interactor?.checkData else { return }
        fullNameView.updateData(checkData: checkData)
        genderView.updateData(checkData: checkData)
        dateOfBirthView.updateData(checkData: checkData)
        cardView.updateData(checkData: checkData)
    }
    
    func updateDateOfBirthLabel(_ dateString: String) {
        dateOfBirthView.updateDateOfBirthLabel(dateString)
    }
    
    func showDateOfBirthError() {
        dateOfBirthView.showDateOfBirthError()
    }
    
    func hideDateOfBirthError() {
        dateOfBirthView.hideDateOfBirthError()
    }
}

// MARK: - KycUpdateInforDateOfBirthViewDelegate
extension KycUpdateInformationViewController: KycUpdateInforDateOfBirthViewDelegate {
    func kycUpdateInforDateOfBirthTap() {
        let dateOfBirth = presenter?.dateOfBirth ?? Date()
        KycCalendarRouter().showScreen(delegate: self,
                                       selectedDate: dateOfBirth)
    }
}

// MARK: - KycCalendarDelegate
extension KycUpdateInformationViewController: KycCalendarDelegate {
    func kycCalendarDidSelectDate(_ date: Date) {
        presenter?.selectDateOfBirth(date)
    }
}
