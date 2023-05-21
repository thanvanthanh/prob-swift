//
//  LegendItemView.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 27/09/2565 BE.
//

import UIKit
class LegendItemView: BaseView {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var titleView: UILabel!
    func setupView(color: UIColor, title: String) {
        colorView.backgroundColor = color
        titleView.text = "\(title)%"
        titleView.textColor = color
        self.setBackgroundColor(color: .clear)
    }
}
