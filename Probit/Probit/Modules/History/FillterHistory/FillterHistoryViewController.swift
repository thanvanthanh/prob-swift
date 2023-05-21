//
//  FillterHistoryViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 12/10/2565 BE.
//  
//

import UIKit

enum TradingType: String {
    case FROM = "FROM"
    case TO = "TO"
}

class FillterHistoryViewController: BaseViewController {
    var filterDelegate: FilterSearchViewDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var dateRangeLabel: UILabel!

    @IBOutlet private weak var fromIconImage: UIImageView!
    @IBOutlet private weak var fromCryptoName: UILabel!
    
    @IBOutlet private weak var toIconImage: UIImageView!
    @IBOutlet private weak var toCryptoName: UILabel!
    
    @IBOutlet weak var currencyView: UIView!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var fromCoinsView: UIView!
    @IBOutlet weak var toCoinsView: UIView!
    @IBOutlet weak var tradingPairLabel: UILabel!
    let datesRate: [DateRateType] = DateRateType.allCases
    var filterModel: SearchFilterModel?

    @IBOutlet weak var errorDateLabel: UILabel!
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        self.filterModel = filterDelegate?.filterModel
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupNavigation()
        setupDateRateCollection()
        setupAction()
    }
    
    override func setupUI() {
        timeZoneLabel.text = localTimeZoneAbbreviation
        setupTradingPair()
        currencyView.isHidden = (presenter?.isHideCurrencyView ?? false)
        updateTimeLabel()
    }
    
    override func localizedString() {
        tradingPairLabel.text = "filter_rowtitle_traidingpair".Localizable()
        dateTitleLabel.text = "filter_rowtitle_dates".Localizable()
        errorDateLabel.text = "filter_daterangeerror".Localizable()
    }
    
    override func setupDarkMode() {
        super.setupDarkMode()
        updateBoderColor()
    }
    
    func updateBoderColor() {
        let borderColor = UIColor.color_e6e6e6_424242
        fromCoinsView.borderColor = borderColor
        toCoinsView.borderColor = borderColor
        collectionView.reloadData()
        guard let filterModel = self.filterModel else { return }
        let rangeOfDate = filterModel.startTime.timeBetweenDate(toDate: filterModel.endTime)
        validateCalendarView(days: rangeOfDate.days)
    }
    
    func validateCalendarView(days: Int) {
        if days > 93 {
            errorDateLabel.isHidden = false
            calendarView.borderColor = UIColor(hexString: "#F25D4E")
        } else {
            errorDateLabel.isHidden = true
            calendarView.borderColor = UIColor.color_e6e6e6_424242
        }
    }
    
    func setupAction() {
        fromCoinsView.addTapGesture { [self] in
            TradingSelectRouter(tradingSelectDelegate: self,
                                typeList: TradingType.FROM.rawValue).showScreen()
        }
        toCoinsView.addTapGesture { [self] in
            TradingSelectRouter(tradingSelectDelegate: self,
                                typeList: TradingType.TO.rawValue).showScreen()
        }
        
        calendarView.addTapGesture { [self] in
            if  let vc = ProbitDatePickerRouter().createModule() as? ProbitDatePickerViewController {
                vc.callback = { dates in
                    self.filterModel?.startTime = dates[0]
                    self.filterModel?.endTime = dates[1]
                    self.filterModel?.updateDateRateSelected(dateType: nil)
                    self.calendarView.borderColor = UIColor.color_e6e6e6_424242
                    self.errorDateLabel.isHidden = true
                    self.updateTimeLabel()
                }
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        }
        
    }
    
    func setupTradingPair() {
        updateFromCoinView()
        updateToCoinView()
    }
    
    func updateFromCoinView() {
        var valueColor = UIColor.color_c8c8c8_646464
        guard let currency = self.filterModel?.baseCurrency else {
            fromIconImage.isHidden = true
            fromCryptoName.text = "filter_allcoins".Localizable()
            fromCryptoName.textColor = valueColor
            return
        }
        valueColor = UIColor.color_424242_fafafa
        fromIconImage.isHidden = false
        fromCryptoName.text = currency.id
        fromCryptoName.textColor = valueColor
        LoadImageUrl.shared.cryptoCurrencyImage(with: currency.id, in: fromIconImage)
    }
    
    func updateToCoinView() {
        var valueColor = UIColor.color_c8c8c8_646464
        guard let currency = self.filterModel?.quoteCurrency else {
            toIconImage.isHidden = true
            toCryptoName.text = "filter_allcoins".Localizable()
            toCryptoName.textColor = valueColor
            return
        }
        valueColor = UIColor.color_424242_fafafa
        toIconImage.isHidden = false
        toCryptoName.text = currency.id
        toCryptoName.textColor = valueColor
        LoadImageUrl.shared.cryptoCurrencyImage(with: currency.id, in: toIconImage)
    }

    // MARK: - Properties
    var presenter: ViewToPresenterFillterHistoryProtocol?
    
    func setupNavigation() {
        setupNavigationBar(title: "filter_search".Localizable(),
                           titleLeftItem: "common_previous".Localizable())
    }
    
    @IBAction func doSearch(_ sender: Any) {
        guard let filterModel = self.filterModel else { return }
        let rangeOfDate = filterModel.startTime.timeBetweenDate(toDate: filterModel.endTime)
        validateCalendarView(days: rangeOfDate.days)
        if rangeOfDate.days <= 93 {
            self.filterDelegate?.filterModel = filterModel
            self.filterDelegate?.doSearch()
            self.filterDelegate?.updateFilterTime(startTime: filterModel.startTime, endTime: filterModel.endTime)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func updateTimeLabel() {
        let startDate = (self.filterModel?.startTime ?? Date()).stringFromDate(format: "yyyy/MM/dd")
        let endDate = (self.filterModel?.endTime ?? Date()).stringFromDate(format: "yyyy/MM/dd")
        self.dateRangeLabel.textColor = UIColor.color_282828_fafafa
        let dateRanger = AppConstant.isLanguageRightToLeft ? "\(endDate) ~ \(startDate)" : "\(startDate) ~ \(endDate)"
        dateRangeLabel.text = dateRanger
    }
    
    func setupDateRateCollection() {
        let nib = UINib(nibName: "DateTypeRateCollectionViewCell", bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        configLayout()
    }
    
    private func configLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
    }
}

extension FillterHistoryViewController: BuyCryptoDelegate {
    func getSpend(data: ListSupported, type: CryptoType) {
//        self.presenter?.updateData(data: data, type: type)
    }
}

extension FillterHistoryViewController: PresenterToViewFillterHistoryProtocol{
    func reloadData() {
        setupTradingPair()
    }
    
    func bindDataView() {
        
    }
    
    // TODO: Implement View Output Methods
}

extension FillterHistoryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datesRate.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = datesRate[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DateTypeRateCollectionViewCell
        let isSelected = item == self.filterModel?.dateRateSelected
        cell.billData(title: item.title, isSelected: isSelected)
        cell.setBackgroundSelected(isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = datesRate[indexPath.row]
        self.filterModel?.updateDateRateSelected(dateType: item)
        self.updateTimeLabel()
        collectionView.reloadData()
    }
}

extension FillterHistoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.width - CGFloat((datesRate.count - 1)) * 8.0
        let width: CGFloat = (screenWidth/CGFloat(datesRate.count))
            return CGSize(width: width,
                          height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

extension FillterHistoryViewController: TradingSelectViewControllerDelegate {
    func listData(type: String) -> [ItemSelectModel] {
        let currencies = presenter?.interactor?.currencies ?? []
        if type == TradingType.FROM.rawValue {
            return currencies.map({ currency in
                ItemSelectModel(title: currency.id ,
                                subTitle: currency.displayName?.localized ?? "",
                                id: currency.id)
            }).sorted(by: {$0.title < $1.title})
        } else {
            guard let listQuoteCurrencyId = presenter?.interactor?.listQuoteCurrencyId else { return [] }
            let filter = currencies.filter({ listQuoteCurrencyId.contains($0.id) })
            return filter.map({ currency in
                ItemSelectModel(title: currency.id ,
                                subTitle: currency.displayName?.localized ?? "",
                                id: currency.id)
            }).sorted(by: {$0.title < $1.title})
        }
    }
    
    func itemSelected(type: String) -> ItemSelectModel? {
        guard let filterModel = filterDelegate?.filterModel else { return nil }
        if type == TradingType.FROM.rawValue {
            guard let currency = filterModel.baseCurrency else { return nil }
            return ItemSelectModel(title: currency.id, subTitle: currency.displayName?.localized ?? "", id: currency.id)
        } else {
            guard let currency = filterModel.quoteCurrency else { return nil }
            return ItemSelectModel(title: currency.id, subTitle: currency.displayName?.localized ?? "", id: currency.id)
        }
    }
    
    func updateSelected(type: String, itemSelected: ItemSelectModel?) {
        if type == TradingType.FROM.rawValue {
            let currency = presenter?.interactor?.currencies.first(where: {$0.id == itemSelected?.id})
            self.filterModel?.baseCurrency = currency
            self.updateFromCoinView()
        } else {
            let currency = presenter?.interactor?.currencies.first(where: {$0.id == itemSelected?.id})
            self.filterModel?.quoteCurrency = currency
            self.updateToCoinView()
        }
        collectionView.reloadData()
    }
}
