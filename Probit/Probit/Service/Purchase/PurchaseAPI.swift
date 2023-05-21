//
//  PurchaseAPI.swift
//  Probit
//
//  Created by Bradley Hoang on 30/09/2022.
//

import Foundation

final class PurchaseAPI: BaseAPI<PurchaseServiceConfiguration> {
    static let shared = PurchaseAPI()
    
    private override init() {}
    
    func getCoinConversionConfig(completionHandler: @escaping (Result<CoinConversionConfigModel, ServiceError>) -> Void) {
        fetchData(configuration: .getCoinConversionConfig,
                  responseType: GetCoinConversionConfigResponseModel.self) { result in
            switch result {
            case let .success(responseModel):
                completionHandler(.success(responseModel.data.prob))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func getConversionRate(completionHandler: @escaping (Result<DataDTO<PurchaseConversionRate>, ServiceError>) -> Void) {
        fetchData(configuration: .getCoinConversionRate,
                  responseType: DataDTO<PurchaseConversionRate>.self) { result in
            completionHandler(result)
        }
    }
    
    func buyCoinConversion(purchaseRequest: PurchaseRequest,
                           completionHandler: @escaping (Result<DataDTO<PurchaseModel>, ServiceError>) -> Void) {
        fetchData(configuration: .buyCoinConversion(fromCurrencyId: purchaseRequest.fromCurrencyId,
                                                    toCurrencyId: purchaseRequest.toCurrencyId,
                                                    toQuantity: purchaseRequest.toQuantity,
                                                    price: purchaseRequest.price,
                                                    stake: purchaseRequest.stake),
                  responseType: DataDTO<PurchaseModel>.self) { result in
            completionHandler(result)
        }
    }
    
    func getHistoryConversion(currencyId: String,
                              completionHandler: @escaping (Result<DataDTO<[PurchaseModel]>, ServiceError>) -> Void) {
           fetchData(configuration: .getHistoryConversion(currencyId: currencyId),
                     responseType: DataDTO<[PurchaseModel]>.self) { result in
               completionHandler(result)
           }
       }
}
