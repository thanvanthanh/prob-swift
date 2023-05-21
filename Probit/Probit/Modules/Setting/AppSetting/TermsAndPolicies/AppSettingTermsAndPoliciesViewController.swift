//
//  AppSettingTermsAndPoliciesViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//  
//

import UIKit

class AppSettingTermsAndPoliciesViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var presenter: ViewToPresenterAppSettingTermsAndPoliciesProtocol?
    private var tableViewDelegate: BaseTableViewDelegate<TermsAndPoliciesTableViewCell>?
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupTable()
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigationBar(title: "fragment_settings_terms".Localizable(),
                                titleLeftItem: "activity_appsettings_title".Localizable())
    }
    
    func setupTable() {
        tableView.showsVerticalScrollIndicator = false
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.sectionHeaderView = presenter?.listTermsSetting.map({ _ in
            HeaderTermsAndPolicies() }) ?? []
        tableViewDelegate?.dataArray = presenter?.listTermsSetting.map({ $0.model }) ?? [[]]
        tableViewDelegate?.setupHeader = setupHeaderView(headerView:section:)
        tableViewDelegate?.removeNoDataView()
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        tableView.reloadData()
    }
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        // TODO: Setup UI for cell
        guard let cell = cell as? TermsAndPoliciesTableViewCell,
              let model = dataItem as? TermSetting else { return }
        cell.setupCell(object: model)
        cell.showTermsButton.did(.touchUpInside) { [weak self] _, _ in
            guard let self = self else { return }
            self.presenter?.navigateToWebView(url: model.name.url)
        }
        
        cell.termsSwitch.did(.valueChanged) { [weak self] _, _ in
            guard let self = self else { return }
            var item = model
            item.isSwitch.toggle()
            self.presenter?.changeStateTerms(term: item)
        }
        
    }
    
    private func didSelectedCell(_ dataItem: Any, _ cell: UITableViewCell) {
    }
    
    func setupHeaderView(headerView: UIView, section: Int) {
        guard let header = headerView as? HeaderTermsAndPolicies else { return }
        guard let model = presenter?.listTermsSetting[section] else { return }
        header.model = model
        header.delegate = self
        
        header.actionView.addTapGesture { [weak self] in
            guard let self = self else { return }
            self.presenter?.headerAction(terms: model)
        }
    }
    
}

extension AppSettingTermsAndPoliciesViewController: PresenterToViewAppSettingTermsAndPoliciesProtocol{
    // TODO: Implement View Output Methods
    func reloadData() {
        tableViewDelegate?.dataArray = presenter?.listTermsSetting.map({ $0.model }) ?? [[]]
    }
}

extension AppSettingTermsAndPoliciesViewController: HeaderTermsAndPoliciesDelegate {
    func longTapHeader(model: TermsAndPolicies?) {
        if let model = model {
            self.presenter?.headerAction(terms: model)
        }
    }
}
