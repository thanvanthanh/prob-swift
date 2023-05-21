//
//  KycSelectCountryViewController.swift
//  Probit
//
//  Created by Bradley Hoang on 02/11/2022.
//  
//

import UIKit

final class KycSelectCountryViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var progressBar: UIProgressView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var countryContainerView: UIView!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var nextButton: StyleButton!
    @IBOutlet private weak var errorLabel: UILabel!
    
    // MARK: - Properties
    var presenter: ViewToPresenterKycSelectCountryProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        nextButton.setEnable(isEnable: false)
        setupNavigationBar(title: "globalkyc_title".Localizable(),
                           titleLeftItem: "navigationbar_settings".Localizable())
        if let pageType = presenter?.interactor?.pageType {
            progressBar.progress = pageType.progressValue
        }
    }
    
    override func localizedString() {
        titleLabel.text = "globalkyc_nationality_subtitle".Localizable()
        errorLabel.text = "globalkyc_nationality_kyclimitedcountry".Localizable()
        nextButton.setTitle("common_next".Localizable(), for: .normal)
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        if presenter?.isSelectIneligibleCountry ?? false {
            countryContainerView.borderColor = UIColor.Basic.red
        } else {
            countryContainerView.borderColor = UIColor.color_e6e6e6_646464
        }
    }
    
    @objc override func tappedLeftBarButton(sender : UIButton) {
        shopPopupPopToKycIntro()
    }
}

// MARK: - IBAction
private extension KycSelectCountryViewController {
    @IBAction func nextButtonTapped(_ sender: Any) {
        presenter?.updateDataCountry()
    }
    
    @IBAction func showListCountriesAction(_ sender: Any) {
        presenter?.navigateToKycListCountries(delegate: self)
    }
}

// MARK: - Private
private extension KycSelectCountryViewController {
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
extension KycSelectCountryViewController: PresenterToViewKycSelectCountryProtocol {
    func selectedCountry(_ country: Country) {
        countryLabel.text = country.fullName
    }
    
    func showIneligibleCountryError(isShow: Bool) {
        errorLabel.isHidden = !isShow
        countryContainerView.borderColor = isShow ? UIColor.Basic.red : UIColor.color_e6e6e6_646464
        nextButton.setEnable(isEnable: !isShow)
    }
}

// MARK: - KycListCountriesDelegate
extension KycSelectCountryViewController: KycListCountriesDelegate {
    func kycListCountriesDidSelectCountry(_ country: Country) {
        presenter?.selectedCountry(country)
    }
}
