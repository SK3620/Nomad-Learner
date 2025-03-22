//
//  AppDelegate.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/09/25.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseAuthUI
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        // 指定したフォントを全画面に適用
        UILabel.appearance().substituteFontName = MyAppSettings.normalFontName
        UILabel.appearance().substituteFontBoldName = MyAppSettings.boldFontName
        
        UITextField.appearance().substituteFontName = MyAppSettings.normalFontName
        
        // GoogleMapSDKとiOSとの紐付け
        let googleMapAPIKey = APIKeys.googleMapAPIKey
        GMSServices.provideAPIKey(googleMapAPIKey)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
           guard let sourceApplication = options[.sourceApplication] as? String? else { fatalError() }
           if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
               return true
           }
           return false
       }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
