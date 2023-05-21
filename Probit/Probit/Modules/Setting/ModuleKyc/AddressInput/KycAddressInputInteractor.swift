//
//  KycAddressInputInteractor.swift
//  Probit
//
//  Created by Bradley Hoang on 09/11/2022.
//  
//

import Foundation

class KycAddressInputInteractor: PresenterToInteractorKycAddressInputProtocol {
    // MARK: Properties
    var presenter: InteractorToPresenterKycAddressInputProtocol?
    var personalInfor: [String: String] = [:]
    var pageType: UserKycStatusDetailModel.PageType = .personalInfo

    func getData() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        validatePage(page: pageType) {
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) { [weak self]  in
            guard let self = self else { return }
            self.getDataKyc(page: self.pageType) {
                self.presenter?.getDataCompleted()
            }
        }
    }
    
    func updatePersionalDataKyc(_ data: [String: String]) {
        self.updateDataKyc(data: data)
    }
}

private extension KycAddressInputInteractor {
    func getDataKyc(page: UserKycStatusDetailModel.PageType,
                    completion: @escaping () -> Void) {
        SettingAPI.shared.getGlobalKycData(page: page) { [weak self] result in
            defer { completion() }
            guard let self = self else { return }
            switch result {
            case let .success(res):
                self.personalInfor = res.data
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
    
    func updateDataKyc(data: [String: String]) {
        SettingAPI.shared.updateDataKyc(data: data) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_ ):
                self.presenter?.updateDataSuccess()
            case .failure(let error):
                self.presenter?.getDataFailed(error)
            }
        }
    }
}
