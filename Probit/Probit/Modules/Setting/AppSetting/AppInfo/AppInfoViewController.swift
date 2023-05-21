//
//  AppInfoViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//  
//

import UIKit

class AppInfoViewController: BaseViewController {
    
    @IBOutlet weak var appVersionInfoLabel: UILabel!
    @IBOutlet weak var currentVersion: UILabel!
    @IBOutlet weak var updateButton: StyleButton!
    @IBOutlet weak var hyperLinkButton: UIButton!
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigationBar(title: "activity_appinfo_title".Localizable(),
                                titleLeftItem: "activity_appsettings_title".Localizable())
        updateButton.setEnable(isEnable: true)
    }
    
    override func localizedString() {
        appVersionInfoLabel.text = "activity_appinfo_appversioninfo".Localizable()
        
        currentVersion.text = "settings_current_version".Localizable() + " \(AppConstant.appVersion)"
        
        updateButton.setTitle("activity_appinfo_update".Localizable(), for: .normal)
    
        hyperLinkButton.setTitle("www.probit.com", for: .normal)
        hyperLinkButton.underline()

    }

    // MARK: - Properties
    var presenter: ViewToPresenterAppInfoProtocol?
    
    @IBAction func updateActions(_ sender: Any) {
        if let url = URL(string: AppConstant.Link.appStoreLink) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func hyperLinkAction(_ sender: Any) {
        presenter?.navigateToHomePage(viewController: self)
    }
}

extension AppInfoViewController: PresenterToViewAppInfoProtocol{
    // TODO: Implement View Output Methods
}
