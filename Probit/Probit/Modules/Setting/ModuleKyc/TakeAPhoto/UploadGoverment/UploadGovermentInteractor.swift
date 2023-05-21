//
//  UploadGovermentInteractor.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 09/11/2565 BE.
//  
//

import Foundation

class UploadGovermentInteractor: PresenterToInteractorUploadGovermentProtocol {
    // MARK: Properties
    let pageType = UserKycStatusDetailModel.PageType.idImage

    var presenter: InteractorToPresenterUploadGovermentProtocol?
    var stylePhoto: StylePhoto?
    
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
}

private extension UploadGovermentInteractor {
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
    
    func getDataKyc(page: UserKycStatusDetailModel.PageType,
                    completion: @escaping () -> Void) {
        SettingAPI.shared.getGlobalKycData(page: page) { [weak self] result in
            defer { completion() }
            guard let self = self else { return }
            switch result {
            case let .success(res):
                let dataKyc = res.data
                guard let idType = dataKyc[UserKycStatusDetailModel.PageType.idType.rawValue],
                      let typeCard = TypeCardId.initValue(idType) else { return }
                self.stylePhoto = .CARD(cardType: typeCard)
            case let .failure(error):
                self.presenter?.getDataFailed(error)
            }
        }
    }
}
