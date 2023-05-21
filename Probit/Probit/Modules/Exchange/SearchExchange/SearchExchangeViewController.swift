//
//  SearchExchangeViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 16/10/2022.
//  
//

import UIKit

class SearchExchangeViewController: BaseViewController {
    @IBOutlet weak var searchBar: CommonSearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteTextSearchbarButton: UIButton!
    private var tableViewDelegate: BaseTableViewDelegate<HomeTableViewCell>?
    var filteredData: [ExchangeTicker] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func setupUI() {
        hideKeyboardWhenTappedAround()
        addObserverKeyBoard()
        setupNavigation()
        setupSearchBar()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presenter?.connect()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.presenter?.disconnect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupNavigation() {
        setupNavigationBar(title: "filter_search".Localizable(),
                           titleLeftItem: (presenter?.keyword.isEmpty ?? false) ? "navigationbar_market".Localizable() : "navigationbar_home".Localizable(),
                           isShowUnderLineColor: false)
    }
    
    func setupTableView() {
        tableView.keyboardDismissMode = .onDrag
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.cellheight = UITableView.automaticDimension
        tableViewDelegate?.emptyType = .search
        tableViewDelegate?.dataArray = [presenter?.coins ?? []]
    }
    
    let backgroundSearchedView = IntroDataSearchView()
    
    func addBackgroundSearchedView(isSearchResultsEmpty: Bool) {
        backgroundSearchedView.introSearchView.isHidden = isSearchResultsEmpty
        backgroundSearchedView.noDataSearchView.isHidden = !isSearchResultsEmpty
        self.tableView.backgroundView = backgroundSearchedView
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.setup(placeholder: "searchbar_hint".Localizable())
        searchBar.setTextField(color: .clear, borderColor: UIColor.Basic.spacingBottom)
        searchBar.setImage(UIImage(named: "ic_clear-text-search"), for: .clear, state: .normal)
        searchBar.returnKeyType = UIReturnKeyType.go
        searchBar.searchTextField.clearButtonMode = .always
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        searchBar.setTextField(color: .clear, borderColor: UIColor.Basic.spacingBottom)
    }
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        if let exchangeCell = cell as? HomeTableViewCell {
            exchangeCell.setupCell(object: dataItem)
        }
    }
    
    private func didSelectedCell(_ dataItem: Any, _ cell: UITableViewCell) {
        guard let indexPath = dataItem as? IndexPath else { return }
        let data = filteredData.isEmpty ? presenter?.coins[indexPath.row] : filteredData[indexPath.row]
        presenter?.navigateToExchangeDetail(exchange: data)
    }
    
    override func updateLayoutWhenKeyboardChanged(height: CGFloat) {
        let border = height == 0.0 ? UIColor.color_e6e6e6_424242 : UIColor.color_4231c8_6f6ff7
        searchBar.setTextField(borderColor: border)
        if filteredData.isEmpty {
            backgroundSearchedView.resetLayoutWhenShowKeyboard(height: height)
        }
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterSearchExchangeProtocol?
    
}

// MARK: - PresenterToView
extension SearchExchangeViewController: PresenterToViewSearchExchangeProtocol{
    func bindData(indexPaths: [Int], exchangeRate: ExchangeRate?, marketData: MarketData?) {
        let coins = presenter?.coins ?? []
        indexPaths.forEach {
            if let cell = tableView.cellForRow(at: IndexPath(row: $0, section: 0)) as? HomeTableViewCell,
               $0 < coins.count {
                cell.updatePrice(usdtRate: coins[$0].quoteRate,
                                 quoteCurrencyID: coins[$0].quoteCurrencyId)
            }
        }
    }
    
    func showFilteredCoins(_ coins: [ExchangeTicker]) {
        tableViewDelegate?.dataArray = [coins]
        if coins.isEmpty {
            let searchText = searchBar.text?.asTrimmed
            addBackgroundSearchedView(isSearchResultsEmpty: !searchText.value.isEmpty)
        }
    }
    
    func setSearchBar(_ text: String) {
        searchBar.text = text
        searchItemAction(text)
    }
    
    func searchItemAction(_ text: String) {
        let allData = presenter?.coins ?? []
        if text.asTrimmed.isEmpty == false {
            filteredData = allData.filter {
                $0.searchResult(searchText: text.asTrimmed.uppercased())
            }.sortResult(with: text)
        } else {
            filteredData = []
        }
        if filteredData.isEmpty {
            if text == "" {
                addBackgroundSearchedView(isSearchResultsEmpty: false)
            } else {
                addBackgroundSearchedView(isSearchResultsEmpty: true)
            }
        }
        tableViewDelegate?.dataArray = [filteredData]
    }
}
// MARK: - UISearchBarDelegate
extension SearchExchangeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        deleteTextSearchbarButton.isHidden = !(searchBar.text == "")
        searchItemAction(searchText.asTrimmed.uppercased())
    }
    
    
    func searchBar(_ searchBar: UISearchBar,
                   shouldChangeTextIn range: NSRange,
                   replacementText text: String) -> Bool {
        return range.location < 50
    }
}
