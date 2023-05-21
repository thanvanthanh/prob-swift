//
//  CommonWebViewViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 07/09/2022.
//  
//

import UIKit
import WebKit
import JavaScriptCore

class CommonWebViewViewController: BaseViewController {
    // MARK: - Properties
    var presenter: ViewToPresenterCommonWebViewProtocol?
    var webView: WKWebView?
    var webConfig: WKWebViewConfiguration {
        get {
            let webCfg = WKWebViewConfiguration()
            let js = getMyJavaScript()
            let script = WKUserScript(
                source: js,
                injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
                forMainFrameOnly: true
            )
            let userController: WKUserContentController = WKUserContentController()
            
            userController.addUserScript(script)
            userController.add(self, name: "ios")
            userController.add(self, name: "clickListener")
            webCfg.userContentController = userController;
            
            return webCfg;
        }
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationUI()
        setupWebView()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView?.reload()
    }
    
    private func setupNavigationUI() {
        setupNavigationBar(title: presenter?.titleNavigation ?? "",
                           titleLeftItem: presenter?.titleBackScreen)
        addRightBarItem(imageName: "ico_reload", imageTouch: "", title: "")
    }
    
    private func setupWebView() {
        webView = WKWebView(frame: .zero, configuration: webConfig)
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0, right: 0)
        webView?.setValue(edgeInsets, forKey: "_obscuredInsets")
        webView?.scrollView.contentInset = edgeInsets
        
        guard let webView = webView else { return }
        webView.navigationDelegate = self
        webView.backgroundColor = UIColor.color_fafafa_181818
        webView.scrollView.backgroundColor = UIColor.color_fafafa_181818
        self.view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        webView.evaluateJavaScript("navigator.userAgent", completionHandler: { (result, error) in
            debugPrint(result as Any)
            if let unwrappedUserAgent = result as? String {
                webView.customUserAgent = "\(unwrappedUserAgent) ProBitiOS/51"
            } else {
                print("failed to get the user agent")
            }
        })
        
        guard let urlString = presenter?.urlString,
              let url = URL(string: urlString) else {
            loadHtmlContent(html: presenter?.html)
            return
        }
        webView.load(URLRequest.init(url: url))
        print("WEBVIEW_URL:", url)
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
    }
    
    override func tappedRightBarButton(sender: UIButton) {
        guard presenter?.urlString != nil else {
            loadHtmlContent(html: presenter?.html)
            return
        }
        webView?.reload()
    }
    
    func getMyJavaScript() -> String {
        if let filepath = Bundle.main.path(forResource: "authentication", ofType: "js") {
            do {
                let path = try String(contentsOfFile: filepath)
                print("JS:", path)
                return path
            } catch {
                return ""
            }
        } else {
            return ""
        }
    }
    
    func sendTokenToJs() {
        var js: String
        if let accessToken = AppConstant.accessToken {
            js = "getTokenFromNative('\(accessToken)')"
        } else {
            js = "getTokenFromNative()"
        }

        /// This WKWebView API to calls 'reloadData' function defined in js
        webView?.evaluateJavaScript(js, completionHandler: { result, error in
            let error = error?.localizedDescription ?? ""
            print("Error: \(error)")
        })
    }
    
    private func getHTML(aURL: String, completion: ((String) -> (Void) )?) {
        guard let url = URL(string: aURL) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let tempHTML = String(data: data, encoding: .utf8) else { return }
            completion?(tempHTML)
        }
        task.resume()
    }
    
    private func loadHtmlContent(html: String?) {
        guard let html = html else { return }
        getHTML(aURL: html) { [weak self] stringHtml in
            let html = """
            <html>
            <head>
            <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
            <style> body { padding: 16px 0px 0px 0px } h2 { color: 4231C8 !important } </style>
            </head>
            <body>
            \(stringHtml)
            </body>
            </html>
            """
            DispatchQueue.main.async {
                guard let webView = self?.webView else { return }
                webView.loadHTMLString(html, baseURL: nil)
            }
            self?.loadHtml(html: html)
        }
    }
    
    func loadHtml(html: String) {
        DispatchQueue.main.async {
            guard let webView = self.webView else { return }
            webView.loadHTMLString(html, baseURL: nil)
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            let backTitle = self.webView?.backForwardList.backItem?.title ?? (presenter?.titleBackScreen  ?? "")
            let navTitle = self.webView?.title ?? (presenter?.titleNavigation ?? "")
            self.setupNavigationBar(title: navTitle, titleLeftItem: backTitle)
        }
    }
    
    deinit {
        webView?.removeObserver(self, forKeyPath: "title")
    }
    
    override func tappedLeftBarButton(sender: UIButton) {
        let canGoBack = self.webView?.canGoBack ?? false
        if canGoBack {
            self.webView?.goBack()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension CommonWebViewViewController: PresenterToViewCommonWebViewProtocol{
    // TODO: Implement View Output Methods
}

extension CommonWebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if let leftTitle = webView.backForwardList.backItem?.title {
            self.setupNavigationBar(titleLeftItem: leftTitle)
        }
        print("WEBVIEW_URL:", webView.url?.absoluteString ?? "")
//        showLoading()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoading()
        print("WEBVIEW_URL:", webView.url?.absoluteString ?? "")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == .linkActivated, let url = navigationAction.request.url {
            decisionHandler(.cancel)
            showPopupHelper("dialog_notice".Localizable(),
                            message: "dialog_navigateaway_content".Localizable(),
                            acceptTitle: "dialog_go".Localizable(),
                            cancleTitle: "dialog_cancel".Localizable(),
                            acceptAction: {
                UIApplication.shared.open(url)
            }, cancelAction: nil)
            return
        }
        decisionHandler(.allow)
    }
}

extension CommonWebViewViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let messageBody = message.body as? String,
              let param = messageBody.toDictionary(),
              let type = param["functionName"] as? String else { return }
        let webViewMessage = WebViewMessage(message: type)
        print("[WEBVIEW_BODY]", messageBody)
        
        print("message:" + (webViewMessage.message ?? ""))
        switch webViewMessage.detectCallBackTtype() {
        case .getToken:
            sendTokenToJs()
        case .requiredLogin:
            PopupHelper.shared.show(viewController: self,
                                    title: "dialog_login_needed_title".Localizable(),
                                    message: "dialog_login_needed_content".Localizable(),
                                    activeTitle: "login_btn_login".Localizable(),
                                    activeAction: { [weak self] in
                                        self?.presenter?.gotoLogin()
                                    },
                                    cancelTitle: "dialog_cancel".Localizable(),
                                    cancelAction: nil)
        case .invalidToken:
            break
        case .move:
            guard let parameters = param["parameters"] as? [String: Any] else { return }
            handleRouteName(parameters: parameters)
            break
        default:
            break
        }
    }
    
    func handleRouteName(parameters: [String: Any]) {
        guard let routeName = parameters["routeName"] as? String else { return }
        let route = WebViewMessageRoute.init(rawValue: routeName) ?? .unknown
        let data = parameters["data"] as? [String]
        
        switch route {
        case WebViewMessageRoute.purchase:
            PurchaseRouter().showScreen()
            break
        case WebViewMessageRoute.deposit:
            let currencyId = data?.first ?? ""
            guard let currency = presenter?.interactor?.walletCurrencies.first(where: { $0.id == currencyId }),
                  let id = currency.id else { return }
            let isSuspended = currency.platform.first(where: {$0.depositSuspended == false}) == nil
            var suspendedType = currency.platform.first(where: {$0.depositSuspended == true})?.suspendedReason ?? .notSupported
            if !isSuspended {
                DepositRouter(walletCurrency: currency).showScreen()
                return
            }
            suspendedType = suspendedType == .empty ? SuspendedReason.notSupported : suspendedType
            
            let suspendedReason = "suspendedreason_\(suspendedType.rawValue)".Localizable()
            let reason = "\(currency.platform.first?.displayName?.name?.localized ?? ""): \(suspendedReason)"
            let message = String.init(format: "dialog_depositwithdrawal_blocked_by_api_content".Localizable(), id, "deposit_nocap".Localizable(), "")
            PopupHelper.shared.show(viewController: self,
                                    title: "dialog_notice".Localizable(),
                                    message: message,
                                    warning: reason,
                                    activeTitle: "common_confirm".Localizable(),
                                    activeAction: nil,
                                    cancelTitle: "dialog_cancel".Localizable(),
                                    cancelAction: nil,
                                    messageColor: UIColor.color_282828_fafafa,
                                    warningColor: UIColor.color_7b7b7b_b6b6b6)
            
            break
        default:
            break
        }
    }
}
