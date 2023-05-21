//
//  TermsViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 22/08/2022.
//  
//

import UIKit

class TermsViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmButton: StyleButton!
    private var tableViewDelegate: BaseTableViewDelegate<TermsTableViewCell>?
    var presenter: ViewToPresenterTermsProtocol?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupTable()
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigationBar(title: "fragment_settings_terms".Localizable(), titleLeftItem: "common_login".Localizable())
    }
    
    override func localizedString() {
        titleLabel.text = "activity_agreement_defaulttitle".Localizable()
        confirmButton.setTitle("common_confirm".Localizable(), for: .normal)
    }
    
    override func hideNavigationBar(isHide: Bool = true) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func tappedLeftBarButton(sender: UIButton) {
        guard presenter?.screenFrom == .signUp else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        let listController = self.navigationController?.viewControllers ?? []
        if let loginIndex = listController.firstIndex(where: { $0 is LoginViewController }) {
            self.navigationController?.popToViewController(listController[loginIndex], animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setupTable() {
        tableViewDelegate = BaseTableViewDelegate(hasPull: false, hasLoadMore: false, tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.dataArray = presenter?.listTerms.map({$0.subContent}) ?? [[]]
        tableViewDelegate?.sectionHeaderView = presenter?.listTerms.map({ _ in TermsHeaderSection() }) ?? []
        tableViewDelegate?.setupHeader = setupHeaderView(headerView:section:)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        showAlertYear()
    }
}

extension TermsViewController: PresenterToViewTermsProtocol {
    // TODO: Implement View Output Methods
    func reloadData() {
        tableViewDelegate?.dataArray = presenter?.listTerms.map({$0.subContent}) ?? [[]]
    }
    
    func setEnableNextButton(_ enable: Bool) {
        self.confirmButton.setEnable(isEnable: enable)
    }

    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        // TODO: Setup UI for cell
        if let termCell = cell as? TermsTableViewCell {
            termCell.setupCell(object: dataItem)
            guard let model = dataItem as? Terms  else { return }
            termCell.viewMoreButton.did(.touchUpInside) { _, _ in
                self.presenter?.navigateToWebView(url: model.name.url)
            }
        }
    }
    
    private func didSelectedCell(_ dataItem: Any, _ cell: UITableViewCell) {
        guard let indexPath = dataItem as? IndexPath else { return }
        presenter?.changeStateSubTerms(indexPath: indexPath)
    }
    
    func setupHeaderView(headerView: UIView, section: Int) {
        guard let header = headerView as? TermsHeaderSection else { return }
        guard let model = presenter?.listTerms[section] else { return }
        header.binding(model: model)
        header.handlerButton.did(.touchUpInside) { _, _ in
            self.presenter?.changeStateTerms(term: model)
        }
        header.viewMoreButton.did(.touchUpInside) { _, _ in
            self.presenter?.navigateToWebView(url: model.name.url)
        }
        header.handlerButton.tag = section
        header.backgroundColor = UIColor.color_fafafa_181818
    }
    
    func showAlertYear() {
        guard presenter?.screenFrom == .signUp else {
            self.presenter?.nextScreen()
            return
        }
        showPopupHelper("activity_notificationsettings_pushelements".Localizable(),
                        message: String(format: "activity_signup_notunderage_content".Localizable(), "18"),
                        warning: nil,
                        acceptTitle: "dialog_serviceagreement_confirmbutton".Localizable(),
                        cancleTitle: nil, acceptAction: { [weak self] in
            guard let `self` = self else { return }
            self.presenter?.nextScreen()
        }, cancelAction: nil)
    }
}
