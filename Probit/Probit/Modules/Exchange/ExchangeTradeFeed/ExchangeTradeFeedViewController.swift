//
//  ExchangeTradeFeedViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 17/10/2022.
//  
//

import UIKit

class ExchangeTradeFeedViewController: BaseViewController {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var recentTrades: [RecentTrade] = []
    private var tableViewDelegate: BaseTableViewDelegate<ExchangeTradeFeedCell>?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupTableView()
    }
    
    override func localizedString() {
        super.localizedString()
        priceLabel.text = "orderform_price".Localizable()
        amountLabel.text = "orderform_amount".Localizable()
        timeLabel.text = "title_TIME".Localizable()
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.cellheight = UITableView.automaticDimension
        tableViewDelegate?.dataArray = [[]]
    }
    
    public func updateData(data: [RecentTrade]) {
        recentTrades.insert(contentsOf: data, at: 0)
        tableViewDelegate?.dataArray = [recentTrades]
    }
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        if let exchangeCell = cell as? ExchangeTradeFeedCell {
            exchangeCell.setupCell(object: dataItem)
        }
    }
    
    private func didSelectedCell(_ dataItem: Any, _ cell: UITableViewCell) {
        
    }
    
    
    // MARK: - Properties
    var presenter: ViewToPresenterExchangeTradeFeedProtocol?
    
}

extension ExchangeTradeFeedViewController: PresenterToViewExchangeTradeFeedProtocol{
    // TODO: Implement View Output Methods
}
