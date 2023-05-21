//
//  TakeAPhotoInteractor.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 07/11/2565 BE.
//  
//

import Foundation

class TakeAPhotoInteractor: PresenterToInteractorTakeAPhotoProtocol {
    
    // MARK: Properties
    var presenter: InteractorToPresenterTakeAPhotoProtocol?
    var stylePhoto: StylePhoto
    init(stylePhoto: StylePhoto) {
        self.stylePhoto = stylePhoto
    }
    
    func getData() {
        
    }
    
    func uploaImage(image: UIImage) {
        SettingAPI.shared.uploadImage(image: image, stylePhoto: stylePhoto) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_ ):
                self.presenter?.uploadImageSucced()
            case .failure(let error):
                self.presenter?.getDataFailed(error)
            }
        }
    }
}

private extension TakeAPhotoInteractor {
    
}
