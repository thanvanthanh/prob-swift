//
//  PaymentMethodViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 24/08/2022.
//  
//

import UIKit

class PaymentMethodViewController: BaseViewController {
    
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var previousButton: HighlightButon!
    @IBOutlet weak var nextButton: StyleButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var secondUnitLabel: UILabel!
    
    // MARK: - Properties
    var presenter: ViewToPresenterPaymentMethodProtocol?
    private var tableViewDelegate: BaseTableViewDelegate<PaymentMethodTableViewCell>?
    private var count = 30
    private var timer: Timer?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimer()
    }
    
    override func localizedString() {
        previousButton.setTitle("common_previous".Localizable(), for: .normal)
        nextButton.setTitle("common_next".Localizable(), for: .normal)
        refreshButton.setTitle("", for: .normal)
    }
    
    override func setupUI() {
        super.setupUI()
        var leftTitle = "common_previous".Localizable()
        let viewControllers = self.getRootTabbarViewController().viewControllers
        if viewControllers.first(where: { $0.className == WalletViewController.className || $0.className == PaymentMethodViewController.className }) != nil {
            leftTitle = presenter?.paymentParams?.crypto ?? ""
        }
        setupNavigationBar(title: "v2icon_home_buycrypto".Localizable(),
                                titleLeftItem: leftTitle)
//        previousButton.borderColor = UIColor.color_4231c8_6f6ff7
//        previousButton.setTitleColor(UIColor.color_4231c8_6f6ff7, for: .normal)
        previousButton.applyOutlineButton1Style()
        self.secondUnitLabel.text = "timedelta_seconds".Localizable()
    }

    override func setupDarkMode() {
        super.setupDarkMode()
        tableView.reloadData()
    }
    
    func setupTable() {
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        tableViewDelegate = BaseTableViewDelegate(hasPull: false,
                                                  hasLoadMore: false,
                                                  tableView: self.tableView)
        tableViewDelegate?.setupCell = setupCell(indexPath:dataItem:cell:)
        tableViewDelegate?.didSelectRow = didSelectedCell(_:_:)
        tableViewDelegate?.dataArray = [[]]
        tableViewDelegate?.noDataMessage = "activity_search_noresult".Localizable()
        
        // setop section
        tableViewDelegate?.sectionHeaderView = presenter?.paymentMethodSection
            .map ({ $0.headerSection ?? BaseView() }) ?? []
        tableViewDelegate?.setupHeader = setupHeaderView(headerView:section:)
    }
    
    @objc
    private func updateCountDownTime() {
        if(count > 0){
            countDownLabel.text = "\(count)"
            count -= 1
        } else {
            timer?.invalidate()
            timer = nil
            startTimer()
        }
    }
    
    private func startTimer() {
        stopTimer()
        count = 29
        countDownLabel.text = "\(count + 1)"
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self, selector: #selector(updateCountDownTime),
                                     userInfo: nil,
                                     repeats: true)
        guard let timer = timer else { return }
        RunLoop.current.add(timer, forMode: .common)
        presenter?.getListPaymentMethod()
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        stopTimer()
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        startTimer()
    }
    
    @IBAction func previousAction(_ sender: Any) {
        stopTimer()
        self.pop()
    }
    
    @IBAction func nextAction(_ sender: Any) {
        presenter?.navigateToConfirmPayment()
    }
    
    // MARK: - TableView delegate, datasource
    private func setupCell(indexPath: IndexPath, dataItem: Any, cell: UITableViewCell) {
        // TODO: Setup UI for cell
        if let termCell = cell as? PaymentMethodTableViewCell {
            termCell.param = presenter?.paymentParams
            termCell.setupCell(object: dataItem)
        }
    }
    
    private func didSelectedCell(_ dataItem: Any, _ cell: UITableViewCell) {
        guard let indexPath = dataItem as? IndexPath else { return }
        presenter?.paymentMethodSelected(item: indexPath)
    }
    
    func setupHeaderView(headerView: UIView, section: Int) {
        guard let header = headerView as? HeaderPaymentMethod else { return }
        guard let model = presenter?.paymentParams else { return }
        header.bindingData(data: model)
    }
    
    override func tappedLeftBarButton(sender: UIButton) {
        let specificViewcontrollers = [CryptoTransfersViewController.className,
                                       StakeDetailsViewController.className,
                                       HomeViewController.className]
        self.popToSpecialViewControlle(specialViewcontrollers: specificViewcontrollers)
    }
}

extension PaymentMethodViewController: PresenterToViewPaymentMethodProtocol{
    
    func reloadData() {
        presenter?.paymentMethodSection.forEach { service in
            service.listData.forEach { data in
                if data.isSelected {
                    self.presenter?.method = data.name
                    self.presenter?.amount = data.price
                }
            }
        }
        
        tableViewDelegate?.sectionHeaderView = presenter?.paymentMethodSection
            .map ({ $0.headerSection ?? BaseView() }) ?? []
        tableViewDelegate?.dataArray = presenter?.paymentMethodSection
            .map({ $0.listData }) ?? [[]]
        
        
        nextButton.isUserInteractionEnabled = true
        nextButton.borderColor = UIColor.color_4231c8_6f6ff7
        nextButton.backgroundColor = UIColor.color_4231c8_6f6ff7
    }
    
    func handleApiError() {
        nextButton.isUserInteractionEnabled = false
        nextButton.borderColor = UIColor.color_b6b6b6_7b7b7b
        nextButton.backgroundColor = UIColor.color_b6b6b6_7b7b7b
        
        showAlert(title: "buycrypto_choosepayment_warning_failtoload".Localizable()) {
            //
        }
    }
}
