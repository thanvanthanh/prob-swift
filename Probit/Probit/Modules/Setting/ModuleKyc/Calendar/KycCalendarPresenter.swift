//
//  KycCalendarPresenter.swift
//  Probit
//
//  Created by Bradley Hoang on 09/11/2022.
//  
//

import Foundation

class KycCalendarPresenter: ViewToPresenterKycCalendarProtocol {
    
    // MARK: - Private Variable
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        dateFormatter.locale = Locale(identifier: AppConstant.locale)
        return dateFormatter
    }
    
    // MARK: Properties
    var view: PresenterToViewKycCalendarProtocol?
    var interactor: PresenterToInteractorKycCalendarProtocol?
    var router: PresenterToRouterKycCalendarProtocol?
    var delegate: KycCalendarDelegate?
    
    var selectedDate: Date = Date()
    
    func viewDidLoad() {
        let dateString = dateFormatter.string(from: selectedDate)
        view?.updateSelectedDateLabel(dateString)
        view?.updateDatePicker(selectedDate)
    }
    
    func datePickerChanged(_ datePicker: UIDatePicker) {
        let dateString = dateFormatter.string(from: datePicker.date)
        view?.updateSelectedDateLabel(dateString)
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
        delegate?.kycCalendarDidSelectDate(date)
    }
    
    func dismissView(_ view: UIViewController) {
        router?.dismissView(view)
    }
}

// MARK: - InteractorToPresenter
extension KycCalendarPresenter: InteractorToPresenterKycCalendarProtocol {
    
}
