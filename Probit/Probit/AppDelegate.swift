//
//  AppDelegate.swift
//  Probit
//
//  Created by Beacon on 10/08/2022.
//

import UIKit
import FirebaseCore
import FirebaseMessaging

enum AppLifecycle {
    case background, foreground
}

protocol CanRotate {

}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var timeInBackground: Int = 0
    
    var state: AppLifecycle = .foreground
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if topViewController(in: window?.rootViewController) is CanRotate {
            return .landscapeRight
        } else {
            return .portrait
        }
    }

    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        state = .foreground
        
        #if ENDPOINT_DEBUG
        print("Debug")
        #elseif ENDPOINT_RELEASE
        print("Release")
        #endif
        // Setup Libs
        let libManager = LibsManager.shared
        libManager.setupLibs(with: window)        
        Messaging.messaging().delegate = self
        configApplePush(application) // register push
        UNUserNotificationCenter.current().delegate = self
        setRootScreen()
        UIView.appearance().semanticContentAttribute = AppConstant.isLanguageRightToLeft ? .forceRightToLeft : .forceLeftToRight
        return true
    }
    
    func setRootScreen() {
        guard AppConstant.showIntroDevice else {
            IntroduceRouter().setupRootView()
            return
        }
        SplashRouter().setupRootView()
    }
    
    func forceLogOut() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let topViewController = UIApplication.shared.getTopViewController()
            topViewController?.showFloatsMessage(message: "force_logout_string".Localizable(), type: .error)
            AppConstant.logout()
            self.setRootScreen()
        }
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("[APPLICATION]: EnterBackgroundground" )
        self.state = .background
        RuntimeConfigService.shared.destroyTimer()
        
        let currenDateTime = Date().timeIntervalSinceReferenceDate
        timeInBackground = Int(currenDateTime)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("[APPLICATION]: EnterForeground" )
        self.state = .foreground
        RuntimeConfigService.shared.startTimer()
        
        // Input pin show when in background after 15 seconds
        if AppConstant.isAppLock && (Int(Date().timeIntervalSinceReferenceDate) - timeInBackground >= 15) {
            if let inputVc = topViewController(in: window?.rootViewController) as? InputPinViewController {
                inputVc.biometricsApp()
            } else {
                InputPinRouter().showScreen(type: .login)
            }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("[APPLICATION]: DidBecomeActive" )
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}


 // MARK: - Config Firebase
extension AppDelegate {

    func configApplePush(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    func topViewController(in rootViewController: UIViewController?) -> UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }

        if let tabBarController = rootViewController as? UITabBarController {
            return topViewController(in: tabBarController.selectedViewController)
        } else if let navigationController = rootViewController as? UINavigationController {
            return topViewController(in: navigationController.visibleViewController)
        } else if let presentedViewController = rootViewController.presentedViewController {
            return topViewController(in: presentedViewController)
        }
        return rootViewController
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    @available(iOS 10, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if let badge = response.notification.request.content.badge as? Int {
            UIApplication.shared.applicationIconBadgeNumber = badge
        }
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        print("FCM token: \(fcmToken)")

        let oldToken = AppConstant.pushToken
        if fcmToken.lengthOfBytes(using: .utf8) > 0 && fcmToken != oldToken {
            AppConstant.pushToken = fcmToken
        }

        if AppConstant.isLogin {
            DispatchQueue.global(qos: .background).async {
                NotificationsAPI.shared.register(deviceToken: AppConstant.pushToken.value) { _ in
                    print("Push Token")
                }
            }
        }
    }
}

extension AppDelegate {

    func requestForNewToken() {
        Messaging.messaging().token { token, error in
            if error != nil {
                print(token.value)
            } else {
                print(error.debugDescription)
            }
        }
    }

    func deleteToken() {
        Messaging.messaging().deleteToken { error in
            if error != nil {
                print(error.debugDescription)
            } else {
                print("delete fcm token")
            }
        }
    }
}

