
import Foundation

class ProbitDatePickerPresenter: ViewToPresenterProbitDatePickerProtocol {
    // MARK: Properties
    var view: PresenterToViewProbitDatePickerProtocol?
    var interactor: PresenterToInteractorProbitDatePickerProtocol?
    var router: PresenterToRouterProbitDatePickerProtocol?
}

extension ProbitDatePickerPresenter: InteractorToPresenterProbitDatePickerProtocol {
    
}
