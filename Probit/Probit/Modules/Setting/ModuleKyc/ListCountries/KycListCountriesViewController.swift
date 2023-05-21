//
//  KycListCountriesViewController.swift
//  Probit
//
//  Created by Bradley Hoang on 02/11/2022.
//  
//

import UIKit

final class KycListCountriesViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var searchBar: CommonSearchBar!
    @IBOutlet private weak var currentLocationContainer: UIView!
    @IBOutlet private weak var currentLocationTitleLabel: UILabel!
    @IBOutlet private weak var currentLocationLabel: UILabel!
    @IBOutlet private weak var countryTitleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private Variable
    private var tableViewDelegate: BaseTableViewDelegate<KycListCountriesCell>?
    
    // MARK: - Properties
    var presenter: ViewToPresenterKycListCountriesProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.onViewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigationBar(title: "globalkyc_title".Localizable(),
                           titleLeftItem: "navigationbar_settings".Localizable(),
                           isShowUnderLineColor: false)
        setupSearchBar()
        setupTableView()
        addObserverKeyBoard()
        
        currentLocationContainer.isHidden = presenter?.selectedCountry == nil
        currentLocationLabel.text = presenter?.selectedCountry?.fullName
    }
    
    override func localizedString() {
        currentLocationTitleLabel.text = "globalkyc_nationality_currentlocation".Localizable()
        countryTitleLabel.text = "globalkyc_nationality_countries".Localizable()
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        searchBar.setTextField(color: .clear,
                               borderColor: UIColor(named: "color_e6e6e6_646464")!)
    }
    
    @IBAction func doClear(_ sender: Any) {
        searchBar.searchTextField.text = ""
    }
    override func updateLayoutWhenKeyboardChanged(height: CGFloat) {
        let border = height == 0.0 ? UIColor.color_e6e6e6_424242 : UIColor.color_4231c8_6f6ff7
        searchBar.setTextField(borderColor: border)
    }
    
//    @objc override func tappedLeftBarButton(sender : UIButton) {
//        shopPopupPopToKycIntro()
//    }
}

// MARK: - Private
private extension KycListCountriesViewController {
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.setup(placeholder: "accessibility_common_search".Localizable())
        searchBar.setTextField(color: .clear,
                               borderColor: UIColor(named: "color_e6e6e6_646464")!)
        searchBar.searchTextField.clearButtonMode = .never
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.color_282828_fafafa
        textFieldInsideSearchBar?.font = UIFont(name: "SFPro-Regular", size: 16)
        
        let labelInsideSearchBar = textFieldInsideSearchBar?.value(forKey: "placeholderLabel") as? UILabel
        labelInsideSearchBar?.textColor = UIColor(named: "color_b6b6b6_646464")
    }
    
    func shopPopupPopToKycIntro() {
        showPopupHelper("globalkyc_activity_closedialog_title".Localizable(),
                        message: "globalkyc_activity_closedialog_content".Localizable(),
                        warning: nil,
                        acceptTitle: "globalkyc_activity_closedialog_confirmbutton".Localizable(),
                        cancleTitle: "globalkyc_activity_closedialog_closebutton".Localizable(),
                        messageColor: UIColor.color_282828_fafafa,
                        acceptAction: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popToViewController(ofClass: SettingViewController.self)
        }, cancelAction: nil)
    }
    
    func setupTableView() {
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.noDataMessage = "stakeevent_nomatch".Localizable()
        tableView.keyboardDismissMode = .onDrag
    }
    
    func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        guard let cell = cell as? KycListCountriesCell else { return }
        cell.setupCell(object: dataItem)
    }
    
    private func didSelectedCell(_ indexPath: IndexPath, _ cell: UITableViewCell) {
        presenter?.onSelectTableViewCell(at: indexPath.row)
        presenter?.onPopToPreviousView(from: self)
    }
}

// MARK: - PresenterToView
extension KycListCountriesViewController: PresenterToViewKycListCountriesProtocol {
    func reloadTableViewData() {
        tableViewDelegate?.dataArray = [presenter?.filterCountries ?? []]
    }
}

// MARK: - UISearchBarDelegate
extension KycListCountriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.onChangeSearchBar(keyword: searchBar.text ?? "")
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
