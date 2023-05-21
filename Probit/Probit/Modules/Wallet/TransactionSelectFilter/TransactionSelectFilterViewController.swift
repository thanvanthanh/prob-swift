
import UIKit

class TransactionSelectFilterViewController: BaseViewController {
    
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var timeZoneLabel: UILabel!
    @IBOutlet weak var collectionView_height: NSLayoutConstraint!

    // MARK: - Properties
    var presenter: ViewToPresenterTransactionSelectFilterProtocol?
    
    private var dates: [Date] = [] {
        didSet {
            if dates.count > 1 {
                self.dateLabel.text = self.dateFormatter.string(from: dates[0]) + " ~ " + self.dateFormatter.string(from: dates[1])
            }
        }
    }
    private var dateSelector: [String] = ["filter_1day".Localizable(), "filter_7days".Localizable(), "filter_1month".Localizable(), "filter_3months".Localizable()]
    private var dateSelected: String? {
        didSet {
            switch dateSelected {
            case "filter_1day".Localizable():
                dates.removeAll()
                dates.append(date)
                dates.append(date)
            case "filter_7days".Localizable():
                dates.removeAll()
                let subOneWeekFromCurrentDate = calendar.date(byAdding: .weekOfYear, value: -1, to: date)
                dates.append(subOneWeekFromCurrentDate ?? Date())
                dates.append(date)
            case "filter_1month".Localizable():
                dates.removeAll()
                let subOneMonthFromCurrentDate = calendar.date(byAdding: .month, value: -1, to: date)
                dates.append(subOneMonthFromCurrentDate ?? Date())
                dates.append(date)
            case "filter_3months".Localizable():
                dates.removeAll()
                let subThreeMonthsFromCurrentDate = calendar.date(byAdding: .month, value: -3, to: date)
                dates.append(subThreeMonthsFromCurrentDate ?? Date())
                dates.append(date)
            default:
                break
            }
            collectionView.reloadData()
        }
    }
    
    private let calendar = Calendar.current
    private let date = Date()
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        return dateFormatter
    }
    
    var callback: (([Date]) -> Void)?
    

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        timeZoneLabel.text = localTimeZoneAbbreviation
        setupCollectionView()
        dateTitleLabel.text = "filter_rowtitle_dates".Localizable()
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: "DateSelectorCell", bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        configLayout()
    }
    
    private func configLayout() {
        let screenWidth = UIScreen.main.bounds.width - 32
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let width: CGFloat = (screenWidth/4) - 16
        let height: CGFloat = width * 4.8 / 8
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 12
        collectionView.collectionViewLayout = layout
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height: CGFloat = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionView_height.constant = height
        view.layoutIfNeeded()
    }
    
    @IBAction func done(_ sender: Any) {
        callback?(dates)
    }
    
    @IBAction func openCalendarSelector(_ sender: Any) {
        if let datePicker = ProbitDatePickerRouter().createModule() as? ProbitDatePickerViewController {
            datePicker.callback = {[weak self] dates in
                guard let self = self else { return }
                self.dates = dates
                self.dateSelected = nil
            }
            present(datePicker, animated: false)
        }
    }
}

extension TransactionSelectFilterViewController: PresenterToViewTransactionSelectFilterProtocol{
}

extension TransactionSelectFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateSelector.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dateSelected = dateSelector[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DateSelectorCell
        let item = dateSelector[indexPath.row]
        cell.configureCell(item, isSelected: item.elementsEqual(dateSelected ?? ""))
        return cell
    }
}
