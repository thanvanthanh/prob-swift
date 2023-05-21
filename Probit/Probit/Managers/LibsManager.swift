//
//  LibsManager.swift
//  Probit
//
//  Created by Thân Văn Thanh on 04/11/2022.
//

import Foundation
import SDWebImageSVGCoder

final class LibsManager {
    
    static let shared = LibsManager()
    
    private init() {}
    
    func setupLibs(with window: UIWindow?) {
        let libsManager = LibsManager.shared
//        libsManager.setupFireBase()
        libsManager.setupSDWebImageSVGCoder()
    }
    
    func setupFireBase() {
//        FirebaseApp.configure()
    }
    
    func setupSDWebImageSVGCoder() {
        let SVGCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(SVGCoder)
    }
}
