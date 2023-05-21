//
//  ShareHelper.swift
//  Probit
//
//  Created by Thân Văn Thanh on 11/10/2022.
//

import Foundation

class ShareHelper: NSObject {
    
    static let shared = ShareHelper()
    
    let topViewController = UIApplication.shared.getTopViewController()
    
    func shareMore(message: String = "", link: String) {
        guard let link = NSURL(string: link),
              let topViewController = UIApplication.shared.getTopViewController() else { return }
        let objectsToShare = [link] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        topViewController.present(activityVC, animated: true, completion: nil)
    }
    
    func shareToFacebook(link: String) {
        guard let url = URL(string: "fb://composer?text=\(link)") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            topViewController?.showFloatsMessage(title: "shareutils_app_is_not_installed".Localizable(),
                                                 type: .error)
        }

    }
    
    func shareToInstagram(link: String) {
        guard let url = URL(string: "instagram://sharesheet?text=\(link)") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            topViewController?.showFloatsMessage(title: "shareutils_app_is_not_installed".Localizable(),
                                                 type: .error)
        }
    }
    
    func shareToTelegram(link: String) {
        guard let url = URL(string: "tg://msg_url?url=\(link)") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            topViewController?.showFloatsMessage(title: "shareutils_app_is_not_installed".Localizable(),
                                                 type: .error)
        }
    }
    
    func shareToLinkedin(link: String) {
        //https://gist.github.com/yidas/4e4b134305770d87be9ac1eca2e6fb6e
        guard let url = URL(string: "linkedin://m/share?text=\(link)") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            topViewController?.showFloatsMessage(title: "shareutils_app_is_not_installed".Localizable(),
                                                 type: .error)
        }
    }
    
}
