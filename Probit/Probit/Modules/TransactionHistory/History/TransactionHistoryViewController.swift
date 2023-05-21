
import UIKit

class TransactionHistoryViewController: BaseViewController {
    // MARK: - Properties
    var presenter: ViewToPresenterTransactionHistoryProtocol?
    @IBOutlet weak var menuBarView: MenuBarView!
    @IBOutlet weak var pageViewController: PageViewController!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       loadDataPageView(page: presenter?.currentPage)
    }
    
    override func setupUI() {
        let title = String.init(format: "activity_currencytransferhistory_title".Localizable(), presenter?.interactor?.currency.id ?? "")
        var leftTitle = "navigationbar_wallet".Localizable()
        let viewControllers = self.getRootTabbarViewController().viewControllers
        let coinDetailViewControllers = [CryptoTransfersViewController.className,
                                         StakeDetailsViewController.className]
        if viewControllers.first(where: {coinDetailViewControllers.contains($0.className)}) != nil {
            leftTitle = presenter?.interactor?.currency.id ?? ""
        }
        setupNavigationBar(title: title,titleLeftItem: leftTitle)
        pageViewController.delegate = self
        pageViewController.initPageView(listData: presenter?.menus ?? [])
        menuBarView.setupMenu(delegate: self)
        presenter?.viewDidLoad()
    }
    
    // MARK: Setup UI
    func loadDataPageView(page: Int?) {
        guard let currentPage = page,
              let menus = presenter?.menus else { return }
        let currentViewController = menus[currentPage].controller as? TransactionListViewController
        currentViewController?.viewPageWillAppear()
        
    }
    
    override func tappedLeftBarButton(sender: UIButton) {
        let viewControllers = self.getRootTabbarViewController().viewControllers
        if let coinDetailINdex = viewControllers.firstIndex(where: { $0.className == CryptoTransfersViewController.className ||  $0.className == StakeDetailsViewController.className}) {
           popToViewController(index: coinDetailINdex, animation: true)
        } else {
            popToRoot()
            self.setupSelectedIndex(index: 3)
        }
    }
}

extension TransactionHistoryViewController: MenuBarViewDelegate {
    func didSelectMenuItem(indexPath: IndexPath) {
        presenter?.didSelectMenuItem(index: indexPath)
        pageViewController.moveSelectedView(index: indexPath.row)
    }
    
    var menus: [MenuBar] {
        get {
            presenter?.interactor?.menus ?? []
        }
        set {
            presenter?.interactor?.menus = newValue
        }
    }
    
    var defaultLeftConstraint: Int {
       return 0
    }
}

extension TransactionHistoryViewController: PresenterToViewTransactionHistoryProtocol{
    func reloadData() {
        menuBarView.reloadView()
    }
    
    func getDataSuccess() {
    }
    
    func applyFilter() {
    }
}

extension TransactionHistoryViewController: PageViewProvider {
    func changeSelectedViewLeftConstraint(_ offset: CGFloat) {
        menuBarView.changeSelectedViewLeftConstraint(offset)
    }
    
    func changePageNumber(_ page: Int) {
        changeSelectedMenuBar(page)
    }
    
    func changeSelectedMenuBar(_ page: Int) {
        let indexPath = IndexPath(row: page, section: 0)
        presenter?.didSelectMenuItem(index: indexPath)
        menuBarView.scrollToItem(indexPath: indexPath)
    }
}
