//
//  UITableViewExtension.swift
//  Probit
//
//  Created by Beacon on 10/08/2022.
//

import Foundation
import UIKit

extension UITableView {
    
    func register<T>(cellType: T.Type) {
        let nib = UINib(nibName:String(describing: T.self), bundle: Bundle.main)
        register(nib, forCellReuseIdentifier: String(describing: T.self))
    }
    
    func registerHeaderFooter<T>(cellType: T.Type) {
        let nib = UINib(nibName:String(describing: T.self), bundle: Bundle.main)
        register(nib, forHeaderFooterViewReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type = T.self) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.className) as? T else {
          fatalError(
            "Failed to dequeue a cell with identifier \(cellType.className) matching type \(cellType.self). "
              + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
              + "and that you registered the cell beforehand"
          )
        }
        return cell
    }
    
       func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type) -> T? {
           return dequeueReusableCell(withIdentifier: type.identifier) as? T
       }
       
       func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type, for indexPath: IndexPath) -> T? {
           return dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T
       }
    
    func dequeueReusableHeaderFooter<T: UIView>(_ cellType: T.Type = T.self) -> T {
        guard let cell = self.dequeueReusableHeaderFooterView(withIdentifier: cellType.className) as? T else {
            fatalError(
              "Failed to dequeue a cell with identifier \(cellType.className) matching type \(cellType.self). "
                + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                + "and that you registered the cell beforehand"
            )
        }
        return cell
    }
    
    func removeFooter() {
        self.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    
    func reloadData(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 1, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    func tableViewNoData(content: String? = nil, icons: String) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0,
                                        width: self.bounds.size.width,
                                        height: self.bounds.size.height))
        let label   = UILabel()
        label.text  = content
        label.font  = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(hexString: "#7B7B7B")
        label.textAlignment  = .center
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        if icons.count > 0 {
            let imageView = UIImageView()
            imageView.image = UIImage(named: icons)
            view.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                imageView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -45)
            ])
            
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                label.centerYAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30)
            ])
        } else {
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
            ])
        }
        return view
    }
    
    func setNoDataView(content: String?, icons: String) {
        self.backgroundView = tableViewNoData(content: content, icons: icons)
    }
    
    func removeNoDataView() {
        self.backgroundView = nil
    }
}

extension UIScrollView {
    func addTopBounceAreaView(color: UIColor = UIColor.color_4231c8_6f6ff7) {
        var frame = UIScreen.main.bounds
        frame.origin.y = -frame.size.height

        let view = UIView(frame: frame)
        view.backgroundColor = color

        self.addSubview(view)
    }
}

public extension UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}

extension UITableView {
    
    func setEmptyView(title: String, message: String, messageImage: UIImage) {
        
        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let messageImageView = UIImageView()
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        messageImageView.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.color_7b7b7b
        titleLabel.font = UIFont(name: "SF Pro", size: 16)
        
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "SF Pro", size: 17)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageImageView)
        emptyView.addSubview(messageLabel)
        
        messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -190).isActive = true
        messageImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        messageImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 16).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageImageView.image = messageImage
        
        titleLabel.text = title
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
//        UIView.animate(withDuration: 1, animations: {
//
//            messageImageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
//        }, completion: { (finish) in
//            UIView.animate(withDuration: 1, animations: {
//                messageImageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
//            }, completion: { (finishh) in
//                UIView.animate(withDuration: 1, animations: {
//                    messageImageView.transform = CGAffineTransform.identity
//                })
//            })
//
//        })
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
}
