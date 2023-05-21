//
//  ThirdPartyDetailViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 08/12/2022.
//  
//

import UIKit
import WebKit

class ThirdPartyDetailViewController: BaseViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let html = presenter?.html else { return }
        webView.loadHTMLString(html, baseURL: nil)
        webView.configuration.userContentController.addUserScript(self.getZoomDisableScript())
        webView.navigationDelegate = self
    }
    
    
    
    override func setupUI() {
        super.setupUI()
        setupNavigationBar(title: "activity_thirdpartylicenses_play_oss".Localizable(),
                           titleLeftItem: "common_previous".Localizable())
    }
    
    private func getZoomDisableScript() -> WKUserScript {
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum- scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }

    // MARK: - Properties
    var presenter: ViewToPresenterThirdPartyDetailProtocol?
    
}

extension ThirdPartyDetailViewController: PresenterToViewThirdPartyDetailProtocol{
    // TODO: Implement View Output Methods
}

extension ThirdPartyDetailViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let javascriptStyle = "var css = '*{-webkit-touch-callout:none;-webkit-user-select:none}'; var head = document.head || document.getElementsByTagName('head')[0]; var style = document.createElement('style'); style.type = 'text/css'; style.appendChild(document.createTextNode(css)); head.appendChild(style);"
            webView.evaluateJavaScript(javascriptStyle, completionHandler: nil)
        }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard case .linkActivated = navigationAction.navigationType,
                  let url = navigationAction.request.url
            else {
                decisionHandler(.allow)
                return
            }
            decisionHandler(.cancel)
        presenter?.navigateToWeb(url: url)
       }
}
