//
//  TickerColorViewController.swift
//  Probit
//
//  Created by Thân Văn Thanh on 31/08/2022.
//  
//

import UIKit

protocol TickerColorDelegate: AnyObject {
    func getTickerColor(options: TickerColor)
}

class TickerColorViewController: BaseViewController {
    
    @IBOutlet weak var buyOption1: UILabel!
    @IBOutlet weak var buyIconOption1: UIImageView!
    @IBOutlet weak var sellOption1: UILabel!
    @IBOutlet weak var sellIconOption1: UIImageView!
    @IBOutlet weak var checkedOption1: UIImageView!
    
    @IBOutlet weak var buyOption2: UILabel!
    @IBOutlet weak var buyIconOption2: UIImageView!
    @IBOutlet weak var sellOption2: UILabel!
    @IBOutlet weak var sellIconOption2: UIImageView!
    @IBOutlet weak var checkedOption2: UIImageView!
    
    // MARK: - Properties
    var presenter: ViewToPresenterTickerColorProtocol?
    private var isSelected: Bool = false
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigationBar(title: "activity_appsettings_v2_tickercolour".Localizable(),
                                titleLeftItem: "activity_appsettings_title".Localizable())
        removeSelected()
        setupSelected()
    }

    override func localizedString() {
        [buyOption1, buyOption2].forEach( { $0?.text = "common_buy".Localizable() })
        [sellOption1, sellOption2].forEach({ $0?.text = "sell_noformat".Localizable() })
    }
    
    private func setupSelected() {
        if AppConstant.tickerColor == .option1 {
            selectOption1()
        } else {
            selectOption2()
        }
    }
    
    private func selectOption1() {
        checkedOption1.isHidden = false
        [buyOption1, sellOption1].forEach {
            $0?.font = UIFont(name: "SFPro-Medium", size: 16)
            $0?.textColor = UIColor.label
        }
        [buyOption2, sellOption2].forEach {
            $0?.font = UIFont(name: "SFPro-Regular", size: 16)
            $0?.textColor = UIColor.color_7b7b7b_b6b6b6
        }
        AppConstant.tickerColor = .option1
    }
    
    private func selectOption2() {
        checkedOption2.isHidden = false
        [buyOption2, sellOption2].forEach {
            $0?.font = UIFont(name: "SFPro-Medium", size: 16)
            $0?.textColor = UIColor.label
        }
        [buyOption1, sellOption1].forEach {
            $0?.font = UIFont(name: "SFPro-Regular", size: 16)
            $0?.textColor = UIColor.color_7b7b7b_b6b6b6
        }
        AppConstant.tickerColor = .option2
    }
    
    private func removeSelected() {
        [checkedOption1, checkedOption2].forEach( { $0?.isHidden = true })
    }
    
    // MARK: - Actions
    @IBAction func selectOption1(_ sender: Any) {
        removeSelected()
        presenter?.chooseTickerColor(tickerColor: .option1)
        selectOption1()
    }
    
    @IBAction func selectOption2(_ sender: Any) {
        removeSelected()
        selectOption2()
        presenter?.chooseTickerColor(tickerColor: .option2)
    }
    
}

extension TickerColorViewController: PresenterToViewTickerColorProtocol{
    // TODO: Implement View Output Methods
}
