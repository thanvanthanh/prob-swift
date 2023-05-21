//
//  PhotoIsClearInteractor.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 08/11/2565 BE.
//  
//

import Foundation

class PhotoIsClearInteractor: PresenterToInteractorPhotoIsClearProtocol {
    
    // MARK: Properties
    var presenter: InteractorToPresenterPhotoIsClearProtocol?
    var stylePhoto: StylePhoto
    var dataKyc: [String: String] = [:]
    init( stylePhoto: StylePhoto) {
        self.stylePhoto = stylePhoto
    }
    
    func getData() {
        let dispatchGroup = DispatchGroup()
        var isFace = true
        switch stylePhoto {
        case .FACE:
            isFace = true
            dispatchGroup.enter()
            validatePage(page: .selfieImage) {
                dispatchGroup.leave()
            }
        case .CARD:
            isFace = false
            dispatchGroup.enter()
            validatePage(page: .idImage) {
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self]  in
            guard let self = self else { return }
            self.getDataKyc(page: isFace ? .selfieImage : .idImage) {
                self.presenter?.getDataCompleted()
            }
        }
    }
    
    func deletePhoto() {
        SettingAPI.shared.deletePhoto(name: stylePhoto.nameSever) { [weak self] result in
            guard let self = self else { return }
            self.presenter?.deletePhotoSucces()
        }
    }
    func nextStep() {
        nextStep(stepName: "step1") { [weak self] in
            guard let `self` = self else { return }
            self.presenter?.nextScreenLoading()
        }
    }
}

private extension PhotoIsClearInteractor {
    func getDataKyc(page: UserKycStatusDetailModel.PageType,
                    completion: @escaping () -> Void) {
        SettingAPI.shared.getGlobalKycData(page: page) { [weak self] result in
            defer { completion() }
            guard let self = self else { return }
            switch result {
            case let .success(res):
                self.dataKyc = res.data
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
    
    func nextStep(stepName: String, completion: @escaping () -> Void) {
        SettingAPI.shared.nextStep(stepName: stepName) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                completion()
            case let .failure(error):
                self.presenter?.getDataFailed(error)
            }
        }
    }
}
