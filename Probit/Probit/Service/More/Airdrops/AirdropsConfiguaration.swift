//
//  AirdropsConfiguaration.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 26/12/2565 BE.
//

import Foundation

enum AirdropsConfiguaration {
    case eventList(page: Int,
                   title: String?,
                   type: TypeEnum?, status: StatusEvent?,
                   service: Service?, displayOn: DisplayOn?,
                   locale: String?)
}


extension AirdropsConfiguaration: Configuration {
    var baseURL: String {
        switch self {
            case .eventList:
            return Constant.Server.baseAPIURL
        }
    }
    
    var path: String {
        switch self {
        default:
            return "api/event/v1/list"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .eventList(let page,let title,
                        let type,let status,
                        let service,let displayOn,
                        let locale):
            var param: [String: Any]  = ["page": page]
            if let title = title {
                param["title"] = title
            }
            if let type = type {
                param["type"] = type.rawValue
            }
            if let status = status {
                param["status"] = status.rawValue
            }
            if let service = service {
                param["service"] = service.rawValue
            }
            if let displayOn = displayOn {
                param["display_on"] = displayOn.rawValue
            }
            if let locale = locale {
                param["locale"] = locale
            }
            return .requestParameters(parameters: param)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [:]
        }
    }
    
    var data: Data? {
        return nil
    }
    
}
