//
//  TabbarContract.swift
//  Probit
//
//  Created by Nguyen Quang on 23/08/2022.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewTabbarProtocol {
   
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterTabbarProtocol {
    
    var view: PresenterToViewTabbarProtocol? { get set }
    var interactor: PresenterToInteractorTabbarProtocol? { get set }
    var router: PresenterToRouterTabbarProtocol? { get set }
    
    func viewDidLoad()
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorTabbarProtocol {
    
    var presenter: InteractorToPresenterTabbarProtocol? { get set }
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterTabbarProtocol {
    
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterTabbarProtocol {
    
}
