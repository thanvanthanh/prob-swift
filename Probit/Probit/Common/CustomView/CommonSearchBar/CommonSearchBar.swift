//
//  CommonSearchBar.swift
//  Probit
//
//  Created by Bradley Hoang on 16/12/2022.
//

import UIKit

final class CommonSearchBar: UISearchBar {
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupRightToLeft(AppConstant.isLanguageRightToLeft)
    }
}

// MARK: - Private

private extension CommonSearchBar {
    func setupRightToLeft(_ isRTL: Bool) {
        semanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
        self.searchTextField.textAlignment = isRTL ? .right : .left
    }
}
