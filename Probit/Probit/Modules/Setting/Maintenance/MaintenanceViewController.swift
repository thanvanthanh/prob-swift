//
//  MaintenanceViewController.swift
//  Probit
//
//  Created by Bradley Hoang on 31/10/2022.
//  
//

import UIKit

final class MaintenanceViewController: BaseViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var detailButton: StyleButton!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var beginTimeLabel: UILabel!
    @IBOutlet private weak var endTimeLabel: UILabel!
    @IBOutlet private weak var detailContentLabel: UILabel!
    
    // MARK: - Properties
    var presenter: ViewToPresenterMaintenanceProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        super.setupUI()
        if let beginMillisecondTime = presenter?.runtimeConfig?.appMaintenanceNoticeFrom {
            let beginTimeInterval = beginMillisecondTime / 1000
            let beginTime = Date(timeIntervalSince1970: TimeInterval(beginTimeInterval))
            beginTimeLabel.text = beginTime.stringFromDateWithSemantic()
        }
        if let endMillisecondTime = presenter?.runtimeConfig?.appMaintenanceNoticeUntil {
            let endTimeInterval = endMillisecondTime / 1000
            let endTime = Date(timeIntervalSince1970: TimeInterval(endTimeInterval))
            endTimeLabel.text = endTime.stringFromDateWithSemantic()
        }
        if let contents = presenter?.runtimeConfig?.appMaintenanceNoticeDisplayName {
            detailContentLabel.text = contents[AppConstant.locale]
        }
    }
    
    override func localizedString() {
        titleLabel.text = "activity_maintenance_title".Localizable()
        timeLabel.text = "activity_maintenance_time_title".Localizable()
        contentLabel.text = "activity_maintenance_affect_title".Localizable()
        detailButton.setTitle("activity_maintenance_button".Localizable(), for: .normal)
        descriptionLabel.text = "activity_maintenance_hint_title".Localizable()
    }
    
    // MARK: - IBAction
    @IBAction func detailButtonTapped(_ sender: Any) {
        guard let url = URL(string: presenter?.runtimeConfig?.appMaintenanceNoticeUrl ?? ""),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}

extension MaintenanceViewController: PresenterToViewMaintenanceProtocol {
    // TODO: Implement View Output Methods
}
