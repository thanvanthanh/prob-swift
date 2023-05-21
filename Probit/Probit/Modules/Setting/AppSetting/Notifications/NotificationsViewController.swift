//
//  NotificationsViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 27/09/2022.
//  
//

import UIKit

class NotificationsViewController: BaseViewController {
    
    @IBOutlet weak var pushNotiTitle: UILabel!
    @IBOutlet weak var pushNotiHintTitle: UILabel!
    
    @IBOutlet weak var dndModeLabel: UILabel!
    @IBOutlet weak var dndHintLabel: UILabel!
    
    @IBOutlet weak var systemLabel: UILabel!
    @IBOutlet weak var systemHintLabel: UILabel!
    
    @IBOutlet weak var settingSystemView: HighlightView!
    @IBOutlet weak var annoucementLabel: UILabel!
    
    @IBOutlet weak var dndSwitch: UISwitch!
    @IBOutlet weak var notiSwitch: UISwitch!
    // MARK: - Properties
    var presenter: ViewToPresenterNotificationsProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigationBar(title: "fragment_settings_notifications".Localizable(),
                                titleLeftItem: "activity_appsettings_title".Localizable())
        settingSystemView.addTapGesture {
            self.presenter?.navigateToSystemSetting()
        }
        dndSwitch.semanticContentAttribute = .forceLeftToRight
        notiSwitch.semanticContentAttribute = .forceLeftToRight
//        addLongPressGestureForHeaderView()
        
        settingSystemView.delegate = self
        settingSystemView.bgColor = .color_fafafa_181818
        settingSystemView.strokeColor = .clear
        settingSystemView.highlightType = .normal
    }
    
    override func localizedString() {
        pushNotiTitle.text = "activity_notificationsettings_pushelements_withdrawaldepositnotification_title".Localizable()
        pushNotiHintTitle.text = "activity_notificationsettings_pushelements_withdrawaldepositnotification_hint".Localizable()
        dndModeLabel.text = "activity_notificationsettings_pushelements_dndsetting_title".Localizable()
        dndHintLabel.text = "activity_notificationsettings_pushelements_dndsetting_hint".Localizable()
        systemLabel.text = "activity_notificationsettings_pushelements_systemsettings_title".Localizable()
        systemHintLabel.text = "activity_notificationsettings_pushelements_systemsettings_hint".Localizable()
        
        let appsetting = "activity_appsettings_title".Localizable()
        let terms = "fragment_settings_terms".Localizable()
        let annoucement = String.init(format: "activity_notificationsettings_v2_probitannoucement_is_in_another_castle".Localizable(),
                                      appsetting,
                                      terms)
        annoucementLabel.text = annoucement
    }


    @IBAction func notificationSwitchChange(_ sender: UISwitch) {
        print(sender.isOn)
    }
    
    @IBAction func dndSwitchChange(_ sender: UISwitch) {
        print(sender.isOn)
    }
    
    @IBAction func systemNotificationAction(_ sender: Any) {
        presenter?.navigateToSystemSetting()
    }
    
}

extension NotificationsViewController: PresenterToViewNotificationsProtocol {
    // TODO: Implement View Output Methods
}

extension NotificationsViewController: HighlightViewProtocol {
    func highlight(view: HighlightView) {
        systemLabel.textColor = UIColor.color_4231c8_6f6ff7
    }
    
    func unHighlight(view: HighlightView) {
        systemLabel.textColor = UIColor.color_282828_fafafa
    }
}
