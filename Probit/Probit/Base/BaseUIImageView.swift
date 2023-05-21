//
//  BaseUIImageView.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 03/12/2565 BE.
//

import UIKit
class BaseUIImageView: UIImageView {
    // MARK: - Init

    override init(image: UIImage?) {
        super.init(image: image)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    /// Shared initializer code
    private func setup() {
        self.detectImageByLanguge()
    }
}
