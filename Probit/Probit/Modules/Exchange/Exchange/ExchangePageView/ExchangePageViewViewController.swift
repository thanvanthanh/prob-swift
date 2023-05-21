//
//  ExchangePageViewViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 26/08/2022.
//  
//

import UIKit
enum ExchangePageType {
    case favorite
    case other(String)
}

class ExchangePageViewViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var presenter: ViewToPresenterExchangePageViewProtocol?
    var exchanges: [ExchangeTicker] = []
    var type: ExchangePageType?
    private var tableViewDelegate: BaseTableViewDelegate<ExchangeTableViewCell>?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.cellheight = UITableView.automaticDimension
        tableViewDelegate?.dataArray = [exchanges]
        // FIXME: Change message empty.
        
        if let _type = type {
            switch _type {
            case .favorite:
                tableViewDelegate?.noDataMessage = "fragment_marketlist_v2_no_data_available_favourite".Localizable()
            case .other(let unit):
                tableViewDelegate?.noDataMessage = String(format:"fragment_marketlist_v2_no_data_available_generic".Localizable(), unit)
            }
        }
        tableViewDelegate?.addNoDataView()
    }
    
    func reloadData(data: [ExchangeTicker]) {
        exchanges = data
        tableViewDelegate?.dataArray = [exchanges]
    }
    
    func bindingData(data: MarketData) {
        exchanges.enumerated().forEach { index, element in
            guard element.id == data.marketId, let ticker = data.ticker else { return }
            element.mapping(withTicker: ticker)
            if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ExchangeTableViewCell {
                cell.setupCell(object: element)
            }
        }
    }
    
    func bindingRates(_ rates: [Usdt]) {
        exchanges.enumerated().forEach { index, element in
            rates.forEach {
                if $0.currencyID == element.quoteCurrencyId {
                    element.changeRate = Double($0.rate)
                    if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ExchangeTableViewCell {
                        cell.setupCell(object: element)
                    }
                }
            }
            
        }
        
    }
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        // TODO: Setup UI for cell
        if let termCell = cell as? ExchangeTableViewCell {
            termCell.setupCell(object: dataItem)
        }
    }
    
    private func didSelectedCell(_ dataItem: Any, _ cell: UITableViewCell) {
        guard let indexPath = dataItem as? IndexPath else { return }
        let data = exchanges[indexPath.row]
        presenter?.navigateToExchangeDetail(exchange: data)
    }
}

extension ExchangePageViewViewController: PresenterToViewExchangePageViewProtocol{
}
