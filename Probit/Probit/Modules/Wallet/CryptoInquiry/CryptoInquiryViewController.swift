
import UIKit

final class CryptoInquiryViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var introView: UIView!

    @IBOutlet private var searchBar: CommonSearchBar!
    
    @IBOutlet weak var introContentView: UIView!
    @IBOutlet weak var iconIntroImage: UIImageView!
    @IBOutlet private var searchBackdropText: UILabel!
    @IBOutlet private var searchBackdropContent: UILabel!
    
    @IBOutlet weak var deleteTextSearchbarButton: UIButton!
    @IBOutlet weak var noDataView: UIStackView!
    @IBOutlet weak var iconNoData: UIImageView!
    @IBOutlet weak var titleNoDataLabel: UILabel!
    
    // MARK: - Properties
    var presenter: ViewToPresenterCryptoInquiryProtocol?
    private var items: [WalletCurrency] = []
    var isIntroView: Bool = true {
        didSet {
            setBackgroundView()
        }
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setBackgroundView()
    }
    
    override func setupUI() {
        super.setupUI()
        introView.isHidden = false
        setupNavigationBar(title: "filter_search".Localizable(),
                           titleLeftItem: "navigationbar_wallet".Localizable(),
                           isShowUnderLineColor: false)
        setupSearchBar()
        setupTableView()
        addObserverKeyBoard()
        hideKeyboardWhenTappedAround()
        searchBar.setImage(UIImage(named: "ic_clear-text-search"), for: .clear, state: .normal)
    }
    
    override func localizedString() {
        searchBackdropText.text = "activity_search_searchbackdrop_title".Localizable()
        searchBackdropContent.text = "activity_search_searchbackdrop_content".Localizable()
        titleNoDataLabel.text = "activity_search_noresult".Localizable()
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        if !items.isEmpty {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var noDataViewSpaceViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var noDataSpaceBottomConstraint: NSLayoutConstraint!
    override func updateLayoutWhenKeyboardChanged(height: CGFloat) {
        let border = height == 0.0 ? UIColor.color_e6e6e6_424242 : UIColor.color_4231c8_6f6ff7
        searchBar.setTextField(borderColor: border)
        if height > 0 {
            noDataViewSpaceViewConstraint.constant -= height/2
            noDataSpaceBottomConstraint.constant -= height/2
        } else {
            noDataViewSpaceViewConstraint.constant = 0
            noDataSpaceBottomConstraint.constant = 0
        }

    }
    
    func setBackgroundView() {
        introContentView.isHidden = !isIntroView
        noDataView.isHidden = isIntroView
    }
    
}

// MARK: - Private
private extension CryptoInquiryViewController {
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.setup(placeholder: "searchbar_hint".Localizable())
        searchBar.setTextField(color: .clear,
                               borderColor: UIColor(named: "color_e6e6e6_646464")!)
    }
    
    func setupTableView() {
        tableView.register(cellType: WalletCurrencyPlatformCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.keyboardDismissMode = .onDrag
    }
}

// MARK: - PresenterToView
extension CryptoInquiryViewController: PresenterToViewCryptoInquiryProtocol{
    // TODO: Implement View Output Methods
    func bindData(_ data: [WalletCurrency]) {
        items = data
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CryptoInquiryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(
            withType: WalletCurrencyPlatformCell.self,
            for: indexPath) as? WalletCurrencyPlatformCell else {
            return UITableViewCell()
        }
        cell.setupCell(object: items[indexPath.row], hideBalances: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count == 0 {
            introView.isHidden = false
            tableView.isHidden = true
            isIntroView = searchBar.text == ""
        }else {
            introView.isHidden = true
            tableView.isHidden = false
            tableView.restore()
        }
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = items[indexPath.row]
        presenter?.didSelectItem(with: currency)
    }
}

// MARK: - UISearchBarDelegate
extension CryptoInquiryViewController: UISearchBarDelegate {
    // TODO: Implement View Output Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        deleteTextSearchbarButton.isHidden = !(searchBar.text == "")
        let searchText = searchText.asTrimmed
        if searchText.isEmpty {
            items.removeAll()
            introView.isHidden = false
            tableView.isHidden = true
            isIntroView = true
        } else {
            introView.isHidden = true
            tableView.isHidden = false
            presenter?.search(searchText)
        }
    }
}
