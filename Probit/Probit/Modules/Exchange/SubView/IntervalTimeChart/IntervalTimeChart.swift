//
//  IntervalTimeChart.swift
//  Probit
//
//  Created by Nguyen Quang on 14/10/2022.
//

import UIKit

protocol IntervalTimeChartDelegate: AnyObject {
    func selectedItem(item: IntervalTimeModel)
    var itemSelected: IntervalTime { get }
    func getData() -> [[IntervalTimeModel]]
    
}

class IntervalTimeChart: BaseView {
    weak var delegate: IntervalTimeChartDelegate?
    @IBOutlet weak var mainStackView: UIStackView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupStackView()
    }
    
    func setupStackView() {
        mainStackView.removeFullyAllArrangedSubviews()
        delegate?.getData().forEach { element in
            let view = buildSectionContent(data: element)
            mainStackView.addArrangedSubview(view)
            mainStackView.addArrangedSubview(buildLineBottom())
        }
        mainStackView.spacer()
    }
    
    private func buildSectionContent(data: [IntervalTimeModel]) -> UIView {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        
        let items = data.chunked(into: 4)
        items.forEach { element in
            let stackView = UIStackView()
            stackView.axis = .horizontal
            
            element.forEach {
                let itemView = buildItemView(item: $0)
                stackView.addArrangedSubview(itemView)
                itemView.translatesAutoresizingMaskIntoConstraints = false
                // Set contraints to full view
                NSLayoutConstraint.activate([
                    itemView.heightAnchor.constraint(equalToConstant: 35),
                    itemView.widthAnchor.constraint(equalToConstant: self.bounds.width / 4)
                ])
            }
            stackView.spacer()
            mainStackView.addArrangedSubview(stackView)
        }
        return mainStackView
    }
    
    
    private func buildItemView(item: IntervalTimeModel) -> UIView {
        let itemView = UIButton()
        let selectedColor = item.model.rawValue == delegate?.itemSelected.rawValue  ? UIColor.Basic.blue : UIColor.Basic.mainText
        itemView.setTitle(item.model.rawValue, for: .normal)
        itemView.setTitleColor(selectedColor, for: .normal)
        itemView.titleLabel?.font = .font(style: .regular, size: 12)
        itemView.did(.touchUpInside) { [weak self] _, _ in
            guard let `self` = self else { return }
            self.selectedItem(item: item)
        }
        return itemView
    }
    
    func selectedItem(item: IntervalTimeModel) {
        setupStackView()
        delegate?.selectedItem(item: item)
    }
    
    private func buildLineBottom() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.Basic.grayText7.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 1)
        ])
        return view
    }
}

class IntervalTimeModel {
    let model: IntervalTime
    init(model: IntervalTime) {
        self.model = model
    }
}

enum IntervalTime: String {
    case minute1 = "1m"
    case minute3 = "3m"
    case minute5 = "5m"
    case minute10 = "10m"
    case minute15 = "15m"
    case minute30 = "30m"
    case hours1 = "1h"
    case hours4 = "4h"
    case hours6 = "6h"
    case hours12 = "12h"
    case day1 = "1D"
    case week1 = "1W"
    case month1 = "1M"
    
    var jsValue: String {
        switch self {
        case .minute1:
            return "1"
        case .minute3:
            return "3"
        case .minute5:
            return "5"
        case .minute10:
            return "10"
        case .minute15:
            return "15"
        case .minute30:
            return "30"
        case .hours1:
            return "60"
        case .hours4:
            return "240"
        case .hours6:
            return "360"
        case .hours12:
            return "720"
        case .day1:
            return "1D"
        case .week1:
            return "1W"
        case .month1:
            return "1M"
        }
    }
    
    var filterValue: String {
        switch self {
        case .minute1:
            return "1m"
        case .minute3:
            return "3m"
        case .minute5:
            return "5m"
        case .minute10:
            return "10m"
        case .minute15:
            return "15m"
        case .minute30:
            return "30m"
        case .hours1:
            return "1h"
        case .hours4:
            return "4h"
        case .hours6:
            return "6h"
        case .hours12:
            return "12h"
        case .day1:
            return "1D"
        case .week1:
            return "1W"
        case .month1:
            return "1M"
        }
    }

    
    var value: String {
        switch self {
        case .minute1:
            return "1"
        case .minute3:
            return "3"
        case .minute5:
            return "5"
        case .minute10:
            return "10"
        case .minute15:
            return "15"
        case .minute30:
            return "30"
        case .hours1:
            return "60"
        case .hours4:
            return "240"
        case .hours6:
            return "360"
        case .hours12:
            return "720"
        case .day1:
            return "1440"
        case .week1:
            return "10080"
        case .month1:
            return "43200"
        }
    }
}
