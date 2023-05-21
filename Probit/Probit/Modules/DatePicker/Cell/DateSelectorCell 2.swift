
import UIKit

class DateSelectorCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet private var date: UILabel!
    @IBOutlet private var view: UIView!

    func configureCell(_ with: String, isSelected: Bool) {
        if isSelected {
            view.backgroundColor = UIColor(hexString: "#4231C8").withAlphaComponent(0.1)
            view.borderColor = UIColor(hexString: "#4231C8")
            date.textColor = UIColor(hexString: "#4231C8")
        } else {
            view.backgroundColor = UIColor(hexString: "#FAFAFA")
            view.borderColor = UIColor(hexString: "#E6E6E6")
            date.textColor = UIColor(hexString: "#C8C8C8")
        }
        date.text = with
    }
}
