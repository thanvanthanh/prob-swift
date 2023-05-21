//
//  StakeCollectionViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 22/09/2565 BE.
//  
//

import UIKit

class StakeCollectionViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var tableViewDelegate: BaseTableViewDelegate<StakeTableViewCell>?
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        tableView.reloadData()
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterStakeCollectionProtocol?
    
    func setupTableView() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = UIColor.color_e6e6e6_424242
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.noDataMessage = "stakeevent_nomatch".Localizable()
        tableViewDelegate?.dataArray = [(presenter?.stakeFilted ?? [])]
    }
    
    func setData(_ listStake: [StakeEventModel],
                 _ currencies: [StakeCurrency],
                 _ walletCurrencies: [WalletCurrency]) {
        self.presenter?.interactor?.stakeCurrencies = currencies
        self.presenter?.interactor?.stakeList = listStake
        self.presenter?.interactor?.walletCurrencies = walletCurrencies
        self.presenter?.filterByTypeStakeList()
    }
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        // TODO: Setup UI for cell
        if let stakeCell = cell as? StakeTableViewCell {
            let stakeEventId = self.presenter?.interactor?.stakeFilted.at(indexPath.row)?.currencyId
            let stakeCurrency = self.presenter?.interactor?.stakeCurrencies.first { currency in
                currency.currencyId == stakeEventId
            }
            stakeCell.setupCell(object: (dataItem, stakeCurrency), indexPath: indexPath)
        }
    }
    
    private func didSelectedCell(_ indexPath: IndexPath, _ cell: UITableViewCell) {
        guard let data = presenter?.stakeFilted.at(indexPath.row),
              data.active ?? false else { return }
        let stakeCurrency = self.presenter?.interactor?.stakeCurrencies.first { currency in
            currency.currencyId == data.currencyId
        }
        if let walletCurrency = self.presenter?.interactor?.walletCurrencies.first(where: {$0.id == data.currencyId}) {
            presenter?.router?.navigateToStakeDetails(stakeEvent: data,
                                                      stakeCurrency: stakeCurrency,
                                                      walletCurrency: walletCurrency)
        }
    }
}

extension StakeCollectionViewController: PresenterToViewStakeCollectionProtocol{
    func reloadData() {
        let stakeFilted = presenter?.stakeFilted ?? []
        tableViewDelegate?.dataArray = [stakeFilted]
    }
    // TODO: Implement View Output Methods
}
