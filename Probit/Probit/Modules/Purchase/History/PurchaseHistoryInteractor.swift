//
//  PurchaseHistoryInteractor.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 19/10/2565 BE.
//  
//

import Foundation

class PurchaseHistoryInteractor: PresenterToInteractorPurchaseHistoryProtocol {
    var listPurChaseModel: [PurchaseModel] = []
    var currencyId: String = "USDT"
    
    func getData() {
        let waitingToStartGroup = DispatchGroup()
        waitingToStartGroup.enter()
        getHistoryConversion {
            waitingToStartGroup.leave()
        }
        waitingToStartGroup.notify(queue: .main) { [weak self] in
            self?.presenter?.getDataSuccess()
        }
    }
    
    // MARK: Properties
    var presenter: InteractorToPresenterPurchaseHistoryProtocol?
}

private extension PurchaseHistoryInteractor {
    func getHistoryConversion(completed: @escaping() -> Void) {
        PurchaseAPI.shared.getHistoryConversion(currencyId: currencyId) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let purchaseData):
                strongSelf.listPurChaseModel = purchaseData.data.sorted(by: {$0.time > $1.time})
            case let .failure(error):
                strongSelf.presenter?.getDataFailed(error)
            }
            completed()
        }
    }
}
