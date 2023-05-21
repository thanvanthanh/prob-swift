//
//  KycCalendarContract.swift
//  Probit
//
//  Created by Bradley Hoang on 09/11/2022.
//  
//

import Foundation
import UIKit

// MARK: View Output (Presenter -> View)
protocol PresenterToViewKycCalendarProtocol {
    func updateSelectedDateLabel(_ dateString: String)
    func updateDatePicker(_ date: Date)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterKycCalendarProtocol {
    var view: PresenterToViewKycCalendarProtocol? { get set }
    var interactor: PresenterToInteractorKycCalendarProtocol? { get set }
    var router: PresenterToRouterKycCalendarProtocol? { get set }
    var delegate: KycCalendarDelegate? { get set }
    
    var selectedDate: Date { get set }
    
    func viewDidLoad()
    func datePickerChanged(_ datePicker: UIDatePicker)
    func selectDate(_ date: Date)
    func dismissView(_ view: UIViewController)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorKycCalendarProtocol {
    var presenter: InteractorToPresenterKycCalendarProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterKycCalendarProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterKycCalendarProtocol {
    func dismissView(_ view: UIViewController)
}

protocol KycCalendarDelegate: AnyObject {
    func kycCalendarDidSelectDate(_ date: Date)
}
