//
//  UITextViewExtension.swift
//  Probit
//
//  Created by Nguyen Quang on 12/10/2022.
//

import Foundation
import WebKit
extension UITextView {
    func htmlAttributed(content: String, family: String, size: CGFloat, color: String) {
        let styleBody = "font-family: \(family) !important; font-size: \(size)px !important; color: #\(color) !important;"
        let htmlString = """
            <html>
                <head>
                    <style>
                        a { \(styleBody) }
                        p { font-family: \(family) !important; font-size: \(size)px !important; }
                    </style>
                </head>
                <body>\(content)</body>
            </html>
            """
        print(htmlString)
        self.textContainer.lineFragmentPadding = CGFloat(0.0)
        self.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        guard let htmlData = NSString(string: htmlString).data(using: String.Encoding.unicode.rawValue) else { return }
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        do {
            let attributedString = try NSAttributedString(data: htmlData, options: options, documentAttributes: nil)
            self.linkTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.init(hexString: color)] as [NSAttributedString.Key: Any]?
            return self.attributedText = attributedString.trimmedAttributedString()
        } catch {
            return
        }
    }
}

extension WKWebView {
    func loadHTMLString(content: String, family: String, size: CGFloat, color: String) {
        let styleBody = "font-family: \(family) !important; font-size: \(size)px !important; color: #\(color) !important;"
        let htmlString = """
            <html>
                <head>
                    <style>
                        a { \(styleBody) }
                        p { font-family: \(family) !important; font-size: \(size)px !important; }
                        body { padding: 0px; margin: 0px;}
                    </style>
                        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
                </head>
                <body>\(content)</body>
            </html>
            """
        self.loadHTMLString(htmlString, baseURL: nil)
    }
}
