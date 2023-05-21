//
//  IntroduceInteractor.swift
//  Probit
//
//  Created by Nguyen Quang on 20/09/2022.
//  
//

import Foundation

class IntroduceInteractor: PresenterToInteractorIntroduceProtocol {
    // MARK: Properties
    var presenter: InteractorToPresenterIntroduceProtocol?
}

enum IntroduceType: CaseIterable {
    case stepOne
    case stepTwo
    case stepThree
    
    var contentView: BaseView {
        switch self {
        case .stepOne:
            return IntroduceStepOne()
        case .stepTwo:
            return IntroduceStepTwo()
        case .stepThree:
            return IntroduceStepThree()
        }
    }
}
