//
//  KycListCountriesCell.swift
//  Probit
//
//  Created by Bradley Hoang on 03/11/2022.
//

import UIKit

final class KycListCountriesCell: BaseTableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var countryLabel: UILabel!
    
    // MARK: - Lifecycle
    override func setupCell(object: Any) {
        guard let model = object as? Country else { return }
        countryLabel.text = model.fullName
    }
}
