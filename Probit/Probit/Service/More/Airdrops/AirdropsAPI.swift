//
//  AirdropsAPI.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 26/12/2565 BE.
//

import Foundation

class AirdropsAPI: BaseAPI<AirdropsConfiguaration> {
    static let shared = AirdropsAPI()
    func getEventList(request: AirdropListRequestModel, completionHandler: @escaping (Result<EventAirdropResponse, ServiceError>) -> Void) {
        fetchData(configuration: .eventList(page: request.page,
                                            title: request.title, type: request.type,
                                            status: request.status, service: request.service,
                                            displayOn: request.displayOn,
                                            locale: request.locale),
                  responseType: EventAirdropResponse.self) { result in
            completionHandler(result)
        }
    }
}

struct EventAirdropResponse: Codable {
    let data: [EventAirdropModel]
    let count: String?
    
    var numberItems: Int { (count ?? "0").asInt }
}
