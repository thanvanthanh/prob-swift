//
//  AppSettingLanguageViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//  
//

import UIKit

class AppSettingLanguageViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var presenter: ViewToPresenterAppSettingLanguageProtocol?
    private var tableViewDelegate: BaseTableViewDelegate<LanguageTableViewCell>?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.getListLanguage()
        setupTable()
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigationBar(title: "settings_app_language".Localizable(),
                                titleLeftItem: "activity_appsettings_title".Localizable())
        
    }
    
    func setupTable() {
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.dataArray = [presenter?.languageAppSetting ?? []]
        tableViewDelegate?.cellheight = 56
    }
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        // TODO: Setup UI for cell
        if let termCell = cell as? LanguageTableViewCell {
            termCell.setupCell(object: dataItem)
        }
    }
    
    private func didSelectedCell(_ dataItem: Any, _ cell: UITableViewCell) {
        guard let indexPath = dataItem as? IndexPath,
              let model = presenter?.languageAppSetting[indexPath.row] else { return }
        showPopupHelper("dialog_notice".Localizable(langCode: model.id),
                        message: "dialog_restart_needed_content".Localizable(langCode: model.id),
                        acceptTitle: "common_confirm".Localizable(langCode: model.id),
                        cancleTitle: "dialog_cancel".Localizable(langCode: model.id),
                        acceptAction: {
            self.presenter?.changeLanguage(indexPath: indexPath)
        }, cancelAction: nil)
    }
    
}

extension AppSettingLanguageViewController: PresenterToViewAppSettingLanguageProtocol{
    // TODO: Implement View Output Methods
    func reloadData() {
        let newData = presenter?.languageAppSetting ?? []
        tableViewDelegate?.dataArray = [newData]
    }
}
