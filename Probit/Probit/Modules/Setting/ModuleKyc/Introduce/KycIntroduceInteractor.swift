//
//  KycIntroduceInteractor.swift
//  Probit
//
//  Created by Bradley Hoang on 01/11/2022.
//  
//

import Foundation

class KycIntroduceInteractor: PresenterToInteractorKycIntroduceProtocol {
  
    
    var kycStatusModel: UserKycStatusDetailModel
    func getData() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        getStatusKyc {
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) { [weak self]  in
            guard let self = self else { return }
            self.presenter?.getDataCompleted()
        }
    }
    
    init(kycStatusModel: UserKycStatusDetailModel) {
        self.kycStatusModel = kycStatusModel
    }
    // MARK: Properties
    var presenter: InteractorToPresenterKycIntroduceProtocol?
    
    func reloadKycData(completion: @escaping () -> Void) {
        SettingAPI.shared.userKycStatus { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(res):
                let data = res.data
                self.kycStatusModel = data
                if data.statusType == .new {
                    self.validatePage(page: .country) {
                        completion()
                    }
                } else if data.statusType == .rejected {
                    self.validatePage(page: data.pageType ?? .country) {
                        completion()
                    }
                } else {
                    completion()
                }
            case let .failure(error):
                self.presenter?.getDataFailed(error)
            }
        }
    }
    
}

private extension KycIntroduceInteractor {
    func getStatusKyc(completion: @escaping () -> Void) {
        SettingAPI.shared.userKycStatus { [weak self] result in
            defer { completion() }
            guard let self = self else { return }
            switch result {
            case let .success(data):
                self.kycStatusModel = data.data
            case let .failure(error):
                self.presenter?.getDataFailed(error)
            }
        }
    }
    
    func validatePage(page: UserKycStatusDetailModel.PageType, completion: @escaping () -> Void) {
        SettingAPI.shared.validatePageKyc(page: page) { [weak self] result in
            defer { completion() }
            guard let self = self else { return }
            switch result {
            case .success(_ ):
                return
            case .failure(let error):
                self.presenter?.getDataFailed(error)
            }
        }
    }
}
