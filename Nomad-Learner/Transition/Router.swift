//
//  Router.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/05.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

protocol RouterProtocol {
    // 初期画面表示
    static func showRoot(window: UIWindow)
    // AuthVC（認証画面）→ MapVC（マップ画面）
    static func showMap(vc: UIViewController, animated: Bool)
}

final class Router {
    // from -> to にプッシュ遷移
    private static func push(from: UIViewController, to: UIViewController, animated: Bool = true) {
        if let nav = from.navigationController {
            nav.pushViewController(to, animated: animated)
        }else {
            from.show(to, sender: nil)
        }
    }
    
    // from -> to にモーダル遷移
    private static func modal(from: UIViewController, to: UIViewController, animated: Bool = true) {
        from.present(to, animated: animated)
    }
}

extension Router: RouterProtocol {
   
    // 初期画面を表示するメソッド
    static func showRoot(window: UIWindow) {
        let authViewController = AuthViewController()
        window.rootViewController = UINavigationController(rootViewController: authViewController)
        window.makeKeyAndVisible()
    }
    
    // AuthVC（認証画面）→ MapVC（マップ画面）
    static func showMap(vc: UIViewController, animated: Bool = true) {
        let mapViewController = MapViewController()
        let navigationController = UINavigationController(rootViewController: mapViewController)
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        modal(from: vc, to: navigationController)
    }
}