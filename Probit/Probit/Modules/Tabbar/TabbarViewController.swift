//
//  TabbarViewController.swift
//  Probit
//
//  Created by Nguyen Quang on 23/08/2022.
//  
//

import UIKit

class TabbarViewController: UITabBarController {
    private var tabbarItems = [TabBarItem]()
    // MARK: - Properties
    var presenter: ViewToPresenterTabbarProtocol?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    func setupTabbarItems(items: [TabBarItem]) {
        tabbarItems = items
        setupCustomTabBar()
        prepareTabbarControllers()
    }
    
    private func setupCustomTabBar() {
        tabBar.backgroundColor = UIColor.color_fafafa_181818
//        tabBar.shadowImage = UIColor.color_e6e6e6_424242.as1ptImage()
        let spacingTopView = UIView.init(frame: CGRect.init(x: 0, y: -1, width: UIScreen.main.bounds.width, height: 1))
        spacingTopView.backgroundColor = UIColor.color_e6e6e6_424242
        view.addSubview(spacingTopView)
        tabBar.addSubview(spacingTopView)
        self.delegate = self
    }
}

extension TabbarViewController: PresenterToViewTabbarProtocol{
    // TODO: Implement View Output Methods
}

extension TabbarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let indexShouldSelect = tabBarController.viewControllers?.firstIndex(of: viewController) {
            if AppConstant.isLogin {
                return true
            }
            var requestType: RequestType = .normal
            
            switch tabbarItems[indexShouldSelect] {
            case .history:
                requestType = .history
            case .wallet:
                requestType = .wallet
            default:
                break
            }
            
            if requestType == .history || requestType == .wallet {
                PopupHelper.shared.show(viewController: viewController.getRootTabbarViewController(),
                                        title: "dialog_login_needed_title".Localizable(),
                                        message: "dialog_login_needed_content".Localizable(),
                                        activeTitle: "login_btn_login".Localizable(),
                                        activeAction: {
                    LoginRouter().showScreen(requestType: requestType)
                }, cancelTitle: "dialog_cancel".Localizable(), cancelAction: nil)
                return false
            } else {
                return true
            }
        }
        return true
   }
}

extension TabbarViewController {
    private func prepareTabbarControllers() {
        var listViewControllers = [UINavigationController]()
        for item in tabbarItems {
            switch item {
            case .home:
                let controller = setupController(HomeRouter().createModule(),
                                                 tabName: item.title,
                                                 image: item.unselectedImage,
                                                 selectedImage: item.selectedImage)
                listViewControllers.append(controller)
            case .exchange:
                let controller = setupController(ExchangeRouter().createModule(),
                                                 tabName: item.title,
                                                 image: item.unselectedImage,
                                                 selectedImage: item.selectedImage)
                listViewControllers.append(controller)
            case .history:
                let controller = setupController(HistoryRouter().createModule(),
                                                 tabName: item.title,
                                                 image: item.unselectedImage,
                                                 selectedImage: item.selectedImage)
                listViewControllers.append(controller)
            case .wallet:
                let controller = setupController(WalletRouter().createModule(),
                                                 tabName: item.title,
                                                 image: item.unselectedImage,
                                                 selectedImage: item.selectedImage)
                listViewControllers.append(controller)
            case .settings:
                let controller = setupController(SettingRouter().createModule(),
                                                 tabName: item.title,
                                                 image: item.unselectedImage,
                                                 selectedImage: item.selectedImage)
                listViewControllers.append(controller)
            }
        }
        self.viewControllers = listViewControllers
    }
    
    func setupController(_ viewController: UIViewController,
                         tabName: String,
                         image: UIImage?,
                         selectedImage: UIImage?) -> UINavigationController {
        let selectedAttributes = [NSAttributedString.Key.foregroundColor: UIColor.color_4231c8_6f6ff7,
                                  NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)]
        let normalAttributes = [NSAttributedString.Key.foregroundColor: UIColor.Basic.grayText,
                                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)]
        tabBar.unselectedItemTintColor = UIColor.Basic.grayText
        
        let tabbarItem = UITabBarItem(title: tabName,
                                      image: image?.withRenderingMode(.alwaysOriginal),
                                      selectedImage: selectedImage?.withRenderingMode(.alwaysOriginal))
        tabbarItem.setTitleTextAttributes(normalAttributes, for: .normal)
        tabbarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        tabbarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
        tabbarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 1)
        
        viewController.tabBarItem = tabbarItem
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.view.backgroundColor = UIColor.color_fafafa_181818
        return navigation
    }
    
    func tabBarIsVisible() ->Bool {
        return orgFrameView == nil
    }
    
    private struct AssociatedKeys {
        // Declare a global var to produce a unique address as the assoc object handle
        static var orgFrameView:     UInt8 = 0
        static var movedFrameView:   UInt8 = 1
    }
    
    var orgFrameView:CGRect? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.orgFrameView) as? CGRect }
        set { objc_setAssociatedObject(self, &AssociatedKeys.orgFrameView, newValue, .OBJC_ASSOCIATION_COPY) }
    }
    
    var movedFrameView:CGRect? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.movedFrameView) as? CGRect }
        set { objc_setAssociatedObject(self, &AssociatedKeys.movedFrameView, newValue, .OBJC_ASSOCIATION_COPY) }
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let movedFrameView = movedFrameView {
            view.frame = movedFrameView
        }
    }
    
}
