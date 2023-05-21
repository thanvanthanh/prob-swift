
import UIKit

enum SwitchViewType {
    case eye, check
}

protocol SwitchViewDelegate: AnyObject {
    func onStateChanged(sender: SwitchView)
}

class SwitchView: BaseView {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var imageViewWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Public Variable
    var type: SwitchViewType = .check {
        didSet {
            updateView()
        }
    }
    var imageWidth: CGFloat = 22 {
        didSet {
            imageViewWidthConstraint.constant = imageWidth
        }
    }
    var imageMode: ContentMode = .scaleAspectFit {
        didSet {
            imageView.contentMode = imageMode
        }
    }
        
    weak var delegate: SwitchViewDelegate?
    
    
    // MARK: - Private Variable
    private(set) var isOn: Bool = false {
        didSet {
            updateView()
            delegate?.onStateChanged(sender: self)
        }
    }
    
    // MARK: - Lifecycle
    override func setupUI() {
        super.setupUI()
        configView()
    }
    
    public func setTitle(_ title: String) {
        self.title.text = title
    }
    
    public func setIsOn(_ isOn: Bool) {
        self.isOn = isOn
    }
    
    private func configView(){
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stateChange)))
        title.isUserInteractionEnabled = true
        title.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stateChange)))
    }
    
    @objc private func stateChange() {
        isOn = !isOn
        UserDefaults.standard.set(isOn, forKey: "is_show_balance")
    }
    
    private func updateView() {
        imageView.image = nil
        var image: UIImage?
        switch type {
        case .check:
            image = UIImage(named: isOn ? "ico_selected" : "ico_not_selected")
            break
        case .eye:
            image = UIImage(named: isOn ? "ico_eye_show" : "ico_eye_hide")
            break
        }
        imageView.image = image
    }
}
