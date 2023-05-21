//
//  AirdropsCollectionPageInteractor.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 26/12/2565 BE.
//  
//

import Foundation

class AirdropsCollectionPageInteractor: PresenterToInteractorAirdropsCollectionPageProtocol {
    // MARK: Properties
    var request: AirdropListRequestModel
    var presenter: InteractorToPresenterAirdropsCollectionPageProtocol?
    var listAirdrop: [EventAirdropModel] = []

    func getData() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        getListAirdrop {
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            guard let `self` = self else { return }
            self.presenter?.getListAirdropSucces()
        })
    }
    
    init(request: AirdropListRequestModel) {
        self.request = request
    }
    
    func nextPage() {
        request.page += 1
        getListAirdrop {
            self.presenter?.getListAirdropSucces()
        }
        
    }
}

extension AirdropsCollectionPageInteractor {
    func getListAirdrop(completed: @escaping() -> Void) {
        AirdropsAPI.shared.getEventList(request: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let res):
                self.listAirdrop.append(contentsOf: res.data)
                if self.listAirdrop.count < res.numberItems {
                    self.presenter?.pageNotEmpty()
                }
            case let .failure(error):
                self.presenter?.handerApiError(error: error)
            }
            completed()
        }
    }
    
}
