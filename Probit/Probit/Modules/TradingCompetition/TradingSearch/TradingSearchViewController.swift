//
//  TradingSearchViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 26/09/2022.
//  
//

import UIKit

class TradingSearchViewController: BaseViewController {
    @IBOutlet weak var searchBar: CommonSearchBar!
    @IBOutlet weak var tableView: UITableView!
    private var tableViewDelegate: BaseTableViewDelegate<TradingCompetitionCell>?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupSearchBar()
        setupTableView()
        addObserverKeyBoard()
        tableView.keyboardDismissMode = .onDrag
        hideKeyboardWhenTappedAround()
        searchBar.tintColor = UIColor.color_282828_fafafa
    }

    func setupNavigation() {
        setupNavigationBar(title: "filter_search".Localizable(),
                           titleLeftItem: "v2icon_home_tc".Localizable(),
                           isShowUnderLineColor: false)
    }
    
    func setupTableView() {
        tableView.separatorInset = .zero
        tableView.separatorColor = UIColor.Basic.grayText
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.cellheight = UITableView.automaticDimension
        tableViewDelegate?.dataArray = [presenter?.tradings ?? []]
        tableViewDelegate?.noDataMessage = "stakeevent_nomatch".Localizable()
        tableViewDelegate?.addNoDataView()
    }
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        if let tradingCell = cell as? TradingCompetitionCell {
            tradingCell.setupCell(object: dataItem)
        }
    }
    
    private func didSelectedCell(_ dataItem: Any, _ cell: UITableViewCell) {
        guard let indexPath = dataItem as? IndexPath,
              let model = presenter?.tradings[indexPath.row] else { return }
        presenter?.navigateToTradingCompetitionDetail(model: model)
    }
    
    private func setupSearchBar() {
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.tintColor = .black
        searchBar.backgroundColor = .clear
        searchBar.searchBarStyle = .minimal
        searchBar.setTextField(color: .clear,
                               borderColor: UIColor.Basic.spacingBottom)
        searchBar.placeholder = "tradecompetition_list_search_searchbar_placeholder".Localizable()
        
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.translatesAutoresizingMaskIntoConstraints = false
            searchTextField.setRightPaddingPoints(12)
            NSLayoutConstraint.activate([
                searchTextField.heightAnchor.constraint(equalToConstant: 36),
                searchTextField.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: 0),
                searchTextField.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 0),
                searchTextField.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor, constant: 0)
            ])
            if let clearButton = searchTextField.value(forKey: "_clearButton") as? UIButton {
                clearButton.setImage(UIImage(named: "ico_exit"), for: .normal)
                clearButton.imageEdgeInsets.right = 5
                clearButton.imageEdgeInsets.left = -5
            }
            searchTextField.clipsToBounds = true
        }
    }
    
    override func updateLayoutWhenKeyboardChanged(height: CGFloat) {
        let border = height == 0.0 ? UIColor.Basic.spacingBottom : UIColor.Basic.blue
        searchBar.setTextField(color: .clear, borderColor: border)
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterTradingSearchProtocol?
    
}

extension TradingSearchViewController: PresenterToViewTradingSearchProtocol {
    // TODO: Implement View Output Methods
}

extension TradingSearchViewController: UISearchBarDelegate {
    // TODO: Implement View Output Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var filteredData: [Trading] = []
        let allData = presenter?.tradingsAll ?? []
        if searchText.asTrimmed.isEmpty == false {
            filteredData = allData.filter({ $0.eventNameEn.uppercased().contains(searchText.asTrimmed.uppercased()) })
        } else {
            filteredData = allData
        }
        presenter?.tradings = filteredData
        tableViewDelegate?.dataArray = [presenter?.tradings ?? []]
    }
}
