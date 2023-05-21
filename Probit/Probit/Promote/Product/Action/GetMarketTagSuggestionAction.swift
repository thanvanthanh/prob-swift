//
//  GetMarketTagSuggestion.swift
//  Probit
//
//  Created by Sotatek on 12/01/2023.
//

import Foundation

class GetMarketTagSuggestionAction: ProductAction<BaseProductResponse<MarketTagSuggestion>> {
    override func apiCall(callback: @escaping (Result<BaseProductResponse<MarketTagSuggestion>, ServiceError>) -> Void) {
        dataSource?.getMarketTagSuggestion(callback: callback)
    }
}
