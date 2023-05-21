//
//  KycCalendarViewController.swift
//  Probit
//
//  Created by Bradley Hoang on 09/11/2022.
//  
//

import UIKit

final class KycCalendarViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var selectButton: UIButton!
    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var currentDateLabel: UILabel!
    
    // MARK: - Properties
    var presenter: ViewToPresenterKycCalendarProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func setupRightToLeft(_ isRTL: Bool) {
        super.setupRightToLeft(isRTL)
        currentDateLabel.textAlignment = isRTL ? .left : .right
    }
    
    override func localizedString() {
        selectButton.setTitle("common_select".Localizable(), for: .normal)
        confirmButton.setTitle("common_confirm".Localizable(), for: .normal)
    }
}

// MARK: - IBAction
private extension KycCalendarViewController {
    @IBAction func selectButtonTapped(_ sender: Any) {
        presenter?.selectDate(datePicker.date)
        presenter?.dismissView(self)
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        presenter?.datePickerChanged(sender)
    }
}

// MARK: - PresenterToView
extension KycCalendarViewController: PresenterToViewKycCalendarProtocol {
    func updateSelectedDateLabel(_ dateString: String) {
        currentDateLabel.text = dateString
    }
    
    func updateDatePicker(_ date: Date) {
        datePicker.date = date
    }
}
