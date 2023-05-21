
import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewProbitDatePickerProtocol {
   
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterProbitDatePickerProtocol {
    var view: PresenterToViewProbitDatePickerProtocol? { get set }
    var interactor: PresenterToInteractorProbitDatePickerProtocol? { get set }
    var router: PresenterToRouterProbitDatePickerProtocol? { get set }
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorProbitDatePickerProtocol {
    var presenter: InteractorToPresenterProbitDatePickerProtocol? { get set }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterProbitDatePickerProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterProbitDatePickerProtocol {
}
