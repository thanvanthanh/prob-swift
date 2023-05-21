//
//  ThirdPartyListInteractor.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/12/2022.
//  
//

import Foundation

class ThirdPartyListInteractor: PresenterToInteractorThirdPartyListProtocol {
    // MARK: Properties
    var presenter: InteractorToPresenterThirdPartyListProtocol?
    var listThirdParty: [ThirdParty] = ThirdParty.allCases
}

enum ThirdParty: CaseIterable {
    case Alamofire
    case InfiniteLayout
    case SdWebImage
    case SnapKit
    case SwiftEntryKit
    case YubiKit
    case SwiftLint
    
    var title: String {
        switch self {
        case .Alamofire:
            return "Alamofire"
        case .InfiniteLayout:
            return "InfiniteLayout"
        case .SdWebImage:
            return "SdWebImage"
        case .SnapKit:
            return "SnapKit"
        case .SwiftEntryKit:
            return "SwiftEntryKit"
        case .YubiKit:
            return "YubiKit"
        case .SwiftLint:
            return "SwiftLint"
        }
    }
    
    var url: String {
        switch self {
        case .Alamofire:
            return ThirdParyHTML.alamofire()
        case .InfiniteLayout:
            return ThirdParyHTML.infiniteLayout()
        case .SdWebImage:
            return ThirdParyHTML.sdWebImage()
        case .SnapKit:
            return ThirdParyHTML.snapKit()
        case .SwiftEntryKit:
            return ThirdParyHTML.swiftEntryKit()
        case .YubiKit:
            return ThirdParyHTML.yubiKit()
        case .SwiftLint:
            return ThirdParyHTML.swiftLint()
        }
    }
}
