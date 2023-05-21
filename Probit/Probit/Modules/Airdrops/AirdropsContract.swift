//
//  AirdropsContract.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 26/12/2565 BE.
//  
//

import Foundation

// MARK: View Output (Presenter -> View)
protocol PresenterToViewAirdropsProtocol {
    func reloadData()
    func hideLoading()
    func showLoading()
    func showError(error: ServiceError)
    func showSuccess(message: String)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterAirdropsProtocol {
    var view: PresenterToViewAirdropsProtocol? { get set }
    var interactor: PresenterToInteractorAirdropsProtocol? { get set }
    var router: PresenterToRouterAirdropsProtocol? { get set }
    var menus: [MenuBar] { get }
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorAirdropsProtocol {
    var presenter: InteractorToPresenterAirdropsProtocol? { get set }
    var menus: [MenuBar] { get }
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterAirdropsProtocol {
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterAirdropsProtocol {
}

struct AirdropListRequestModel {
    var page: Int
    var title: String?
    var type: TypeEnum?
    var status: StatusEvent?
    var service: Service?
    var displayOn: DisplayOn?
    var locale: String?
}

typealias AirdropLocalizableModel = [String: AirdropLocale]
extension AirdropLocalizableModel {
    var localized: AirdropLocale? {
        return self[AppConstant.locale]
    }
}

struct AirdropLocale: Codable {
    var link: String?
    var imgURL: String?
    var landingImgURL, title: String?

    enum CodingKeys: String, CodingKey {
        case link
        case imgURL = "imgUrl"
        case landingImgURL = "landingImgUrl"
        case title
    }
}


struct EventAirdropModel: Codable {
    var id: String?
    var locale: AirdropLocalizableModel?
    var startTime, endTime: String?
    var eventLink: String?
    var type: TypeEnum?
    var solo: Bool?
    var service: Service?
    var displayOn: [DisplayOn]?

    enum CodingKeys: String, CodingKey {
        case id, locale
        case startTime = "start_time"
        case endTime = "end_time"
        case eventLink = "event_link"
        case type, solo, service
        case displayOn = "display_on"
    }
}

enum StatusEvent: String, Codable {
    case ended = "ended"
    case running = "running"
    case active = "active"
    case all = "all"
}

enum DisplayOn: String, Codable {
    case events = "events"
    case landing = "landing"
    case listing = "listing"
}

enum TypeEnum: String, Codable {
    case events = "events"
    case exclusive = "exclusive"
    case info = "info"
    case listing = "listing"
}

enum Service: String, Codable {
    case all = "all"
    case global = "global"
    case korea = "korea"
}
