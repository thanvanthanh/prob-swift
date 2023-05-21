//
//  ListSupportedViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 24/08/2022.
//  
//

import UIKit

class ListSupportedViewController: BaseViewController {
    
    @IBOutlet weak var searchContentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    
    // MARK: - Properties
    var presenter: ViewToPresenterListSupportedProtocol?
    
    private var tableViewDelegate: BaseTableViewDelegate<ListSupportedTableViewCell>?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        presenter?.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        searchTextField.backgroundColor = .clear
        searchTextField.delegate = self
        searchTextField.setupSemantic()
        clearButton.isHidden = true
    }
    
    override func localizedString() {
        guard let type = presenter?.interactor?.cryptoType else { return }
        let subTitle = type == .fiat ? "buycrypto_choosepurchaseamount_selectfiat_description".Localizable() : "buycrypto_choosepurchaseamount_selectcrypto_description".Localizable()
        searchTextField.placeholder = "filter_search".Localizable()
        setupNavigationBar(title: "v2icon_home_buycrypto".Localizable(),
                                subtitle: subTitle,
                                titleLeftItem: "v2icon_home_buycrypto".Localizable())
        searchView.isHidden = type == .crypto
    }
    
    func setupTable() {
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.dataArray = [presenter?.listSupported ?? []]
        tableViewDelegate?.noDataMessage = "activity_search_noresult".Localizable()
        tableViewDelegate?.cellheight = 58
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        searchContentView.layer.borderColor = UIColor.color_e6e6e6_646464.cgColor
    }
    
    @IBAction func clearAction(_ sender: Any) {
        clearButton.isHidden = true
        searchTextField.text?.removeAll()
        presenter?.filterData(searchText: searchTextField.text.value)
    }
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        if let cell = cell as? ListSupportedTableViewCell {
            guard let data = dataItem as? ListSupported else { return }
            let isSelect = data.name == self.presenter?.isSelectType
            cell.setupCell(object: dataItem)
            cell.showCheckMark(isSelect)
        }
    }
    
    private func didSelectedCell(_ dataItem: Any, _ cell: UITableViewCell) {
        guard let indexPath = dataItem as? IndexPath else { return }
        guard let data = presenter?.listSupported[indexPath.row],
              let type = presenter?.interactor?.cryptoType else { return }
        presenter?.selectedData(data: data, type: type)
        self.pop()
    }
    
}

extension ListSupportedViewController: PresenterToViewListSupportedProtocol{
    func reloadData() {
        let listData = presenter?.listSupported ?? []
        tableViewDelegate?.dataArray = [listData]
    }
}

// MARK: - TextField Delegate
extension ListSupportedViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        presenter?.filterData(searchText: updatedString ?? "")
        clearButton.isHidden = updatedString.value.isEmpty
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchContentView.borderColor = UIColor.color_4231c8_6f6ff7
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchContentView.borderColor = UIColor.color_e6e6e6_646464
    }
    
}
