//
//  TradingSelectViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 14/10/2565 BE.
//  
//

import UIKit

class TradingSelectViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var imageSelect: UIImageView!
    @IBOutlet weak var viewSelectAll: UIView!
    
    @IBOutlet weak var allCoinsLabel: UILabel!
    // MARK: - Properties
    var presenter: ViewToPresenterTradingSelectProtocol?
    private var tableViewDelegate: BaseTableViewDelegate<ListSupportedTableViewCell>?
    var isSelectAll: Bool = false {
        didSet {
            imageSelect.isHidden = !isSelectAll
            viewSelectAll.backgroundColor = isSelectAll ? UIColor.color_e6e6e6_282828 : .clear
        }
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        presenter?.viewDidLoad()
    }

    override func setupUI() {
        searchTextField.backgroundColor = .clear
        searchTextField.setupSemantic()
        searchTextField.delegate = self
        setupNavigationBar(title: "filter_selectcrypto".Localizable(),
                           titleLeftItem: "common_previous".Localizable(),
                           isShowUnderLineColor: false)
        isSelectAll = presenter?.interactor?.itemSelected() == nil
        viewSelectAll.addTapGesture(action: { [weak self] in
            guard let self = self,
                  let interactor = self.presenter?.interactor else { return }
            let delegate = interactor.delegate
            delegate.updateSelected(type: interactor.typeList, itemSelected: nil)
            self.isSelectAll = false
            self.pop()
        })
        hideKeyboardWhenTappedAround()
    }
    
    override func localizedString() {
        searchTextField.placeholder = "filter_search".Localizable()
        allCoinsLabel.text = "filter_allcoins".Localizable()
    }
    
    func setupTable() {
        tableView.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        tableView.showsVerticalScrollIndicator = false
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.noDataMessage = "activity_search_noresult".Localizable()
        tableViewDelegate?.dataArray = [presenter?.interactor?.listFilted ?? []]
        tableViewDelegate?.cellheight = 56
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        searchView.borderColor = UIColor.color_e6e6e6_646464
        tableView.reloadData()
    }
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        // TODO: Setup UI for cell
        if let cell = cell as? ListSupportedTableViewCell {
            guard let data = dataItem as? ItemSelectModel else { return }
            cell.setupCell(object: dataItem)
            cell.showCheckMark(data.id == presenter?.interactor?.itemSelected()?.id)
        }
    }
    
    private func didSelectedCell(_ dataItem: Any, _ cell: UITableViewCell) {
        guard let indexPath = dataItem as? IndexPath else { return }
        guard let data = presenter?.interactor?.listFilted[indexPath.row],
        let interactor = self.presenter?.interactor else { return }
        let delegate = interactor.delegate
        isSelectAll = presenter?.interactor?.itemSelected() == nil
        delegate.updateSelected(type: interactor.typeList, itemSelected: data)
        self.pop()
    }
}

extension TradingSelectViewController: PresenterToViewTradingSelectProtocol{
    func reloadData() {
        let listData = presenter?.interactor?.listFilted ?? []
        tableViewDelegate?.dataArray = [listData]
        viewSelectAll.isHidden = presenter?.interactor?.listFilted.count != presenter?.interactor?.listData.count
    }
}

// MARK: - TextField Delegate
extension TradingSelectViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        presenter?.filterData(searchText: updatedString ?? "")
        return true
    }
}
