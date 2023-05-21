//
//  NotificationsAPI.swift
//  Probit
//
//  Created by Thân Văn Thanh on 03/11/2022.
//

import Foundation

class NotificationsAPI: BaseAPI<NotificationsServiceConfiguration> {
    static let shared = NotificationsAPI()
    
    func register(deviceToken: String,
                  completionHandler: @escaping (Result<NotificationsModel, ServiceError>) -> Void) {
        fetchData(configuration: .register(deviceToken: deviceToken),
                  responseType: NotificationsModel.self) { result in
            completionHandler(result)
        }
    }
}
