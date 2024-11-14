//
//  SceneDelegate.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/09/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let realmService = RealmService.shared

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window
        Router.showRoot(window: window)
    }
    
    // app switcher からアプリが閉じられた時に呼ばれる
    func sceneDidDisconnect(_ scene: UIScene) {
        // 下記の処理が少々難しいため暫定的な処理として、Realmからデータを削除
        
        // アプリ2回目以降の起動では、realmにあるfixedLocationを取得しつつも、
        // RealtimeDatabaseの"fixedLocations"の値の更新のみを監視＆更新データのrealmへの保存/取得を行うような処理が望ましい
        realmService.deleteFixedLocations()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
