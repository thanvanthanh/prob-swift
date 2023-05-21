//
//  UpdateVersionViewController.swift
//  Probit
//
//  Created by Bradley Hoang on 24/10/2022.
//  
//

import UIKit

final class UpdateVersionViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var updateButton: StyleButton!
    
    // MARK: - Properties
    var presenter: ViewToPresenterUpdateVersionProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar(isHide: true)
    }
    
    override func localizedString() {
        titleLabel.text = "dialog_force_update_title".Localizable()
        descriptionLabel.text = "dialog_force_update_content".Localizable()
        updateButton.setTitle("dialog_force_update_button".Localizable(), for: .normal)
    }
    
    // MARK: - IBAction
    @IBAction private func updateButtonTapped(_ sender: Any) {
        if let url = URL(string: AppConstant.Link.appStoreLink) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - PresenterToViewUpdateVersionProtocol
extension UpdateVersionViewController: PresenterToViewUpdateVersionProtocol {
    // TODO: Implement View Output Methods
}
