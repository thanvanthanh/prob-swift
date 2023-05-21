//
//  GetTickerAction.swift
//  Probit
//
//  Created by Nguyen Quang on 06/10/2022.
//

import Foundation

class GetTickerAction: ProductAction<BaseProductResponse<Ticker>> {
    
    override init(dataSource: ProductService) {
        super.init(dataSource: dataSource)
    }
    
    override func apiCall(callback: @escaping (Result<BaseProductResponse<Ticker>, ServiceError>) -> Void) {
        dataSource?.getTicker(callback: callback)
    }
}
