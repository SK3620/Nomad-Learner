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

// 画面の向き
enum ScreenOrientation {
    case portrait // 縦向き
    case landscape // 横向き
}

protocol RouterProtocol {
    // 初期画面表示
    static func showRoot(window: UIWindow)
    // AuthVC（認証画面）→ MapVC（マップ画面）
    static func showMap(vc: UIViewController)
    // MapVC（マップ画面）/ StudyRoomVC（勉強部屋画面）→ ProfileVC（プロフィール画面）
    static func showProfile(vc: UIViewController)
    // ProfileVC → EditProfileVC（プロフィール編集画面）
    static func showEditProfile(vc: UIViewController)
    // MacVC（マップ画面）→ DepartVC（出発画面）
    static func showDepartVC(vc: UIViewController)
    // DepartVC（出発画面）→ StudyRoomVC（勉強部屋画面）
    static func showStudyRoomVC(vc: UIViewController)
    
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
    static func showMap(vc: UIViewController) {
        let mapViewController = MapViewController()
        let navigationController = UINavigationController(rootViewController: mapViewController)
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        modal(from: vc, to: navigationController)
    }
    
    // MapVC（マップ画面）/ StudyRoomVC（勉強部屋画面）→ ProfileVC（プロフィール画面）
    static func showProfile(vc: UIViewController) {
        let profileViewController = ProfileViewController(orientation: orientation(vc))
        profileViewController.modalPresentationStyle = .overFullScreen
        profileViewController.modalTransitionStyle = .crossDissolve
        modal(from: vc, to: profileViewController)
    }
    
    // ProfileVC（プロフィール画面）→ EditProfileVC（プロフィール編集画面）
    static func showEditProfile(vc: UIViewController) {
        let profileViewController = EditProfileViewController()
        profileViewController.modalPresentationStyle = .overFullScreen
        profileViewController.modalTransitionStyle = .crossDissolve
        modal(from: vc, to: profileViewController)
    }
    
    // MacVC（マップ画面）→ DepartVC（出発画面）
    static func showDepartVC(vc: UIViewController) {
        let departViewController = DepartViewController()
        departViewController.modalPresentationStyle = .overFullScreen
        departViewController.modalTransitionStyle = .crossDissolve
        modal(from: vc, to: departViewController)
    }
    
    // DepartVC（出発画面）→ StudyRoomVC（勉強部屋画面）
    static func showStudyRoomVC(vc: UIViewController) {
        let studyRoomViewController = StudyRoomViewController()
        let navigationController = NavigationControllerForStudyVC(rootViewController: studyRoomViewController)
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        modal(from: vc, to: navigationController)
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

extension Router {
    // 遷移元画面に応じて画面を縦向きか横向きにするか判定
    private static func orientation(_ vc: UIViewController) -> ScreenOrientation {
        return vc is StudyRoomViewController ? .landscape : .portrait
    }
}
