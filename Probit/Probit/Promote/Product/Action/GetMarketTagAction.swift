//
//  GetMarketTag.swift
//  Probit
//
//  Created by Sotatek on 12/01/2023.
//

import Foundation

class GetMarketTagAction: ProductAction<BaseProductResponse<MarketTag>> {
    override func apiCall(callback: @escaping (Result<BaseProductResponse<MarketTag>, ServiceError>) -> Void) {
        dataSource?.getMarketTag(callback: callback)
    }
}
