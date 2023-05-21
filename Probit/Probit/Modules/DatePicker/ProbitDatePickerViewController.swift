
import UIKit

class ProbitDatePickerViewController: BaseViewController {
    
    @IBOutlet private var startDateText: UILabelPadded!
    @IBOutlet private var endDateText: UILabelPadded!
    @IBOutlet private var selectText: UILabel!
    @IBOutlet private var picker: UIDatePicker!
    @IBOutlet private var confirm: UIButton!
    
    @IBOutlet weak var backView: UIView!
    var callback: (([Date]) -> Void)?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPicker()
        startDateText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickStartDate)))
        endDateText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickEndDate)))
        self.backView.addTapGesture { [weak self] in
            guard let `self` = self else { return }
            self.dismiss(isAnimated: false, transitionType: .fromBottom, onCompleted: {})
        }
        pickStartDate()
        setupButton()
    }
    
    override func localizedString() {
        super.localizedString()
        selectText.text = "filter_title".Localizable()
        let start = "tradecompetition_main_info_start".Localizable()
        let end = "tradecompetition_main_info_end".Localizable()
        let dates = "filter_rowtitle_dates".Localizable()
        startDateText.text = AppConstant.isLanguageRightToLeft ? "\(dates) \(start)" : "\(start) \(dates)"
        endDateText.text =  AppConstant.isLanguageRightToLeft ? "\(dates) \(end)" : "\(end) \(dates)"
        confirm.setTitle("common_confirm".Localizable(), for: .normal)
    }
    
    func setupButton() {
        confirm.setTitleColor(UIColor.color_b6b6b6_7b7b7b, for: .disabled)
        confirm.setTitleColor(UIColor.color_4231c8_6f6ff7, for: .normal)
        confirm.addTarget(self, action: #selector(done), for: .touchUpInside)
    }
    
    func setupPicker() {
        picker.datePickerMode = .date
        picker.maximumDate = today
        picker.timeZone = TimeZone(secondsFromGMT: 0)
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    @objc func pickStartDate() {
        confirm.isEnabled = false
        startDateEditing = true
        endDateEditing = false
        if endDate != nil {
            endDate = nil
        }
        picker.setDate(today, animated: true)
        startDate = picker.date
    }
    
    @objc func pickEndDate() {
        confirm.isEnabled = true
        startDateEditing = false
        endDateEditing = true
        picker.setDate(today, animated: true)
        endDate = picker.date
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let date = sender.date
        if startDateEditing {
            startDate = date
        } else if endDateEditing {
            endDate = date
            guard let startDate = startDate, let endDate = endDate else { return }
            if endDate < startDate {
                self.endDate = self.startDate
                picker.setDate(startDate, animated: true)
            }
        }
    }
    
    @objc func done() {
        guard let startDate = startDate, let endDate = endDate else { return }
        dates.removeAll()
        dates.append(startDate)
        dates.append(endDate)
        dismiss(isAnimated: false, transitionType: .fromBottom) { [weak self] in
            guard let self = self else { return }
            self.callback?(self.dates)
        }
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterProbitDatePickerProtocol?
    var today: Date = Date()
    private var startDate: Date? {
        didSet {
            guard let startDate = startDate else {
                return
            }
            startDateText.textColor = UIColor.color_282828_fafafa
            startDateText.text = dateFormatter.string(from: startDate)
        }
    }
    
    private var endDate: Date? {
        didSet {
            guard let endDate = endDate else {
                endDateText.textColor = UIColor.color_b6b6b6_7b7b7b
                return
            }
            endDateText.textColor = UIColor.color_282828_fafafa
            endDateText.text = dateFormatter.string(from: endDate)
        }
    }
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        return dateFormatter
    }
    private var dates: [Date] = []
    
    private var startDateEditing: Bool = false {
        didSet {
            if startDateEditing {
                startDateText.borderColor = UIColor.color_4231c8_6f6ff7
            } else {
                startDateText.borderColor = UIColor.color_e6e6e6_646464
            }
        }
    }
    private var endDateEditing: Bool = false {
        didSet {
            if endDateEditing {
                endDateText.borderColor = UIColor.color_4231c8_6f6ff7
            } else {
                endDateText.borderColor = UIColor.color_e6e6e6_646464
            }
        }
    }
}

extension ProbitDatePickerViewController: PresenterToViewProbitDatePickerProtocol{
    // TODO: Implement View Output Methods
}
