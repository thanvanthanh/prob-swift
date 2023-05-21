//
//  SelectTypeIdPhotoInteractor.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 08/11/2565 BE.
//  
//

import Foundation

class SelectTypeIdPhotoInteractor: PresenterToInteractorSelectTypeIdPhotoProtocol {
    let pageType = UserKycStatusDetailModel.PageType.idType
    var typeCardSelected: TypeCardId?

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
    
    // MARK: Properties
    var presenter: InteractorToPresenterSelectTypeIdPhotoProtocol?
    
    func updateIdTypeDataKyc(_ data: TypeCardId) {
        self.typeCardSelected = data
        updateDataKyc(data: [pageType.rawValue: data.rawValue])
    }
    
    
}
private extension SelectTypeIdPhotoInteractor {
    func getDataKyc(page: UserKycStatusDetailModel.PageType,
                    completion: @escaping () -> Void) {
        SettingAPI.shared.getGlobalKycData(page: page) { [weak self] result in
            defer { completion() }
            guard let self = self else { return }
            switch result {
            case let .success(res):
                if let typeSelectStr = res.data[self.pageType.rawValue] {
                    self.typeCardSelected = TypeCardId.initValue(typeSelectStr)
                }
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
