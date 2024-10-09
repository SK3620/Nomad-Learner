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
    // MapVC（マップ画面）→ ProfileVC（プロフィール画面）
    static func showProfile(vc: UIViewController, animated: Bool)
    
    // UINavigationを通して戻る
    static func navigationBack(vc: UIViewController)
    // モーダルで戻る
    static func dismissModal(vc: UIViewController, animated: Bool)
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
    
    // UINavigationを通して戻る
    static func pushBack(from nav: UINavigationController, animated: Bool = true) {
        nav.popViewController(animated: animated)
    }
    
    // モーダルで戻る
    private static func dismiss(from vc: UIViewController, animated: Bool = true) {
        vc.dismiss(animated: animated)
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
    
    // MapVC（マップ画面）→ ProfileVC（プロフィール画面）
    static func showProfile(vc: UIViewController, animated: Bool) {
        let profileViewController = ProfileViewController()
        profileViewController.modalPresentationStyle = .overFullScreen
        profileViewController.modalTransitionStyle = .crossDissolve
        modal(from: vc, to: profileViewController)
    }
    
    // モーダルで戻る
    static func dismissModal(vc: UIViewController, animated: Bool = true) {
        dismiss(from: vc, animated: animated)
    }
    
    // UINavigationを通して戻る
    static func navigationBack(vc: UIViewController) {
        guard let nav = vc.navigationController else { return }
        pushBack(from: nav)
    }
}
