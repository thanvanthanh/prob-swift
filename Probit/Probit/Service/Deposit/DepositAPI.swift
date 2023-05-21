//
//  DepositAPI.swift
//  Probit
//
//  Created by Nguyen Quang on 03/02/2023.
//

import Foundation

class DepositAPI: BaseAPI<DepositConfiguration> {
    static let shared = DepositAPI()
    
    func getExplorerCore(completionHandler: @escaping (Result<[ExplorerCore], ServiceError>) -> Void) {
        fetchData(configuration: .explorerCoreDeposit,
                  responseType: [ExplorerCore].self) { result in
            completionHandler(result)
        }
    }
}
