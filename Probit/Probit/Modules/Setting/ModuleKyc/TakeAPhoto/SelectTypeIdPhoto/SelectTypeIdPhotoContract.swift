//
//  SelectTypeIdPhotoContract.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 08/11/2565 BE.
//  
//

import Foundation
import UIKit

// MARK: View Output (Presenter -> View)
protocol PresenterToViewSelectTypeIdPhotoProtocol: BaseViewProtocol {
   func reloadData()
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterSelectTypeIdPhotoProtocol {
    var view: PresenterToViewSelectTypeIdPhotoProtocol? { get set }
    var interactor: PresenterToInteractorSelectTypeIdPhotoProtocol? { get set }
    var router: PresenterToRouterSelectTypeIdPhotoProtocol? { get set }
    func setTypeCardSelected(_ data: TypeCardId)
    func viewDidLoad()

}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorSelectTypeIdPhotoProtocol {
    var pageType: UserKycStatusDetailModel.PageType { get }
    var presenter: InteractorToPresenterSelectTypeIdPhotoProtocol? { get set }
    var typeCardSelected: TypeCardId? { get set }
    func updateIdTypeDataKyc(_ data: TypeCardId)
    func getData()
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterSelectTypeIdPhotoProtocol {
    func getDataFailed(_ error: ServiceError)
    func getDataCompleted()
    func updateDataSuccess()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterSelectTypeIdPhotoProtocol {
}

public enum TypeCardId: String, Codable {
    case PASSPORT = "passport"
    case ID_CARD_FONT_SIDE = "government_id"
    case ID_CARD_BACK_SIDE = "government_id_back"
    case DRIVING_FONT_LICENSE = "drivers_license"
    case DRIVING_BACK_LICENSE = "drivers_license_back"

    var title: String {
        switch self {
        case .PASSPORT:
            return "globalkyc_idtype_passport".Localizable()
        case .ID_CARD_FONT_SIDE, .ID_CARD_BACK_SIDE:
            return "globalkyc_idtype_nationalid".Localizable()
        case .DRIVING_FONT_LICENSE, .DRIVING_BACK_LICENSE:
            return  "globalkyc_idtype_driverslicense".Localizable()
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .PASSPORT:
            return UIImage(named: "ico_passport")
        case .ID_CARD_FONT_SIDE, .ID_CARD_BACK_SIDE:
            return UIImage(named: "ico_id_card")
        case .DRIVING_FONT_LICENSE, .DRIVING_BACK_LICENSE:
            return UIImage(named: "ico_driving_license")
        }
    }
    
    var image: UIImage? {
        switch self {
        case .PASSPORT:
            return UIImage(named: "img_goverment")
        case .ID_CARD_FONT_SIDE, .ID_CARD_BACK_SIDE:
            return UIImage(named: "img_goverment")
        case .DRIVING_BACK_LICENSE, .DRIVING_FONT_LICENSE:
            return UIImage(named: "img_goverment")
        }
    }
    
    var nameSever: String {
        switch self {
        case .PASSPORT:
            return "id_image"
        case .ID_CARD_FONT_SIDE, .DRIVING_FONT_LICENSE:
            return "id_image"
        case .ID_CARD_BACK_SIDE, .DRIVING_BACK_LICENSE:
            return "id_back_image"
        }
    }
    
    static func initValue(_ value: String) -> TypeCardId? {
        switch value {
        case TypeCardId.PASSPORT.rawValue:
            return .PASSPORT
        case TypeCardId.ID_CARD_FONT_SIDE.rawValue:
            return .ID_CARD_FONT_SIDE
        case TypeCardId.DRIVING_FONT_LICENSE.rawValue:
            return .DRIVING_FONT_LICENSE
        default:
            return nil
        }
    }
}


enum LoadingResult: String, Codable {
    case INVALID = "invalid"
    case NEED_CHECK = "need_check"
    case SUCCCES = "success"
    case NEED_CONFIRM = "need_confirm"
}

enum LoadingStatus: String, Codable {
    case STEP1_BEGIN = "step1_begin"
    case STEP1_DONE = "step1_done"
}

struct CheckDataModel: Codable {
    var idImage, idBackImage: String?
    var inputData, ocrData: InputOrcModel?

      enum CodingKeys: String, CodingKey {
          case idImage = "id_image"
          case idBackImage = "id_back_image"
          case inputData = "input_data"
          case ocrData = "ocr_data"
      }
}

struct InputOrcModel: Codable {
    var name, gender, birthday: String?
}

struct LoadingKycModel: Codable {
    var status: LoadingStatus
    var result: LoadingResult
}

struct ValidOCRModel: Codable {
    var idType: TypeCardId?
    var idImage: String?
    var idBackImage: String?
    var loadingResult: LoadingResult?
    
    init(_ data: [String: String]) {
        if let text = data["id_type"],
           !text.isEmpty {
            idType = TypeCardId.initValue(text)
        }
        
        if let text = data["id_image"],
           !text.isEmpty {
            idImage = text
        }

        if let text = data["id_back_image"],
           !text.isEmpty {
            idBackImage = text
        }
        
        if let text = data["loading_result"],
           !text.isEmpty {
            loadingResult = LoadingResult.init(rawValue: text)
        }
    }
}
