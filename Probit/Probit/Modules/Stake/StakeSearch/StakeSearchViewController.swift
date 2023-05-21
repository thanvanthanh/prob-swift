//
//  StakeSearchViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 23/09/2565 BE.
//  
//

import UIKit

class StakeSearchViewController: BaseViewController {
    @IBOutlet weak var seerchBar: CommonSearchBar!
    @IBOutlet weak var stakeTable: UITableView!
    
    private var tableViewDelegate: BaseTableViewDelegate<StakeTableViewCell>?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterStakeSearchProtocol?
    
    private func setupSearchBar() {
        seerchBar.sizeToFit()
        seerchBar.tintColor = .black
        seerchBar.backgroundColor = .clear
        seerchBar.searchBarStyle = .minimal
        seerchBar.setTextField(color: .clear,
                               borderColor: UIColor.Basic.blue)
        seerchBar.placeholder = "filter_search".Localizable()
        if let searchTextField = seerchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                searchTextField.heightAnchor.constraint(equalToConstant: 48),
                searchTextField.leadingAnchor.constraint(equalTo: seerchBar.leadingAnchor, constant: 0),
                searchTextField.trailingAnchor.constraint(equalTo: seerchBar.trailingAnchor, constant: 0),
                searchTextField.centerYAnchor.constraint(equalTo: seerchBar.centerYAnchor, constant: 0)
            ])
            searchTextField.clipsToBounds = true
        }
        seerchBar.delegate = self
        seerchBar.becomeFirstResponder()
    }
    
    override func setupUI() {
        hideKeyboardWhenTappedAround()
    }
    
    func setupNavigation() {
        setupNavigationBar(title: "filter_search".Localizable(),
                                titleLeftItem: "v2icon_home_stake".Localizable())
    }
    
    func setupTableView() {
        stakeTable.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.stakeTable)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.noDataMessage = "stakeevent_nomatch".Localizable()
        tableViewDelegate?.dataArray = [(presenter?.stakeListSearch ?? [])]
    }
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        // TODO: Setup UI for cell
        if let stakeCell = cell as? StakeTableViewCell {
            let stakeEventId = self.presenter?.interactor?.stakeListSearch.at(indexPath.row)?.currencyId
            let stakeCurrency = self.presenter?.interactor?.stakeCurrencies.first { currency in
                currency.currencyId == stakeEventId
            }
            stakeCell.setupCell(object: (dataItem, stakeCurrency), indexPath: indexPath)
        }
    }
    
    private func didSelectedCell(_ indexPath: IndexPath, _ cell: UITableViewCell) {
        guard let data = presenter?.stakeListSearch[indexPath.row],
              data.active ?? false else { return }
        let stakeCurrency = self.presenter?.interactor?.stakeCurrencies.first { currency in
            currency.currencyId == data.currencyId
        }
        if let walletCurrency = self.presenter?.interactor?.walletCurrencies.first(where: {$0.id == data.currencyId}) {
            if AppConstant.isLogin {
                StakeDetailsRouter(parentTypeVC: .STAKE_SEARCH).showScreen(stakeEvent: data,
                                                stakeCurrency: stakeCurrency,
                                                walletCurrency: walletCurrency)
            } else {
                PopupHelper.shared.show(viewController: self,
                                        title: "kyc_fail_to_read_notice_title".Localizable(),
                                        message: "dialog_login_needed_content".Localizable(),
                                        activeTitle: "login_btn_login".Localizable(),
                                        activeAction: {
                    LoginRouter().showScreen()
                }, cancelTitle: "dialog_cancel".Localizable(), cancelAction: nil)
            }
        }
      
    }
}

extension StakeSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.doSearch(searchBar.text ?? "")
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

extension StakeSearchViewController: PresenterToViewStakeSearchProtocol{
    // TODO: Implement View Output Methods
    
    func reloadTableSearch() {
        tableViewDelegate?.dataArray = [(presenter?.stakeListSearch ?? [])]
    }
}
