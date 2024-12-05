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
import RxSwift

// 画面の向き
enum ScreenOrientation {
    case portrait // 縦向き
    case landscape // 横向き
}

// 画面の種類を示す
// 特定の画面から戻った時にさせたい処理の判定をさせる
enum ScreenType {
    case studyRoomVC
    case departVC
}

protocol RouterProtocol {
    // 初期画面表示
    static func showRoot(window: UIWindow)
    // AuthVC（認証画面）→ MapVC（マップ画面）
    static func showMap(vc: UIViewController)
    // MapVC（マップ画面）→ WalkThrough（ウォークスルー画面）
    static func showWalkThoughVC(vc: UIViewController)
    // MapVC（マップ画面）/ StudyRoomVC（勉強部屋画面）→ ProfileVC（プロフィール画面）
    static func showProfile(vc: UIViewController, with userProfile: User)
    // ProfileVC → EditProfileVC（プロフィール編集画面）
    static func showEditProfile(vc: UIViewController, with userProfile: User)
    // MapVC（マップ画面）→ DepartVC（出発画面）
    static func showDepartVC(vc: UIViewController, locationInfo: LocationInfo)
    // DepartVC（出発画面）→ OnFlightVC（飛行中画面）
    static func showOnFlightVC(vc: UIViewController, locationInfo: LocationInfo)
    // OnFlightVC（飛行中画面）→ StudyRoomVC（勉強部屋画面）
    static func showStudyRoomVC(vc: UIViewController, locationInfo: LocationInfo, userProfiles: [User], latestLoadedDocDate: Timestamp?, oldestDocument: QueryDocumentSnapshot?)
    // StudyRoomVC（勉強部屋画面）→ TicketBackgroundVC（チケット確認画面）
    static func showTicketConfirmVC(vc: UIViewController, locationInfo: LocationInfo)
    // StudyRoomVC（勉強部屋画面）→ BackgroundImageSwitchIntervalSelectVC（背景画像切り替えインターバル時間選択画面）
    static func showBackgroundImageSwitchIntervalSelectVC(vc: UIViewController, currentIntervalTime: Int, didIntervalTimeSelect: @escaping (Int) -> Void)

    // StudyRoomVC（勉強部屋画面）/ EditProfileVC（プロフィール編集画面）→ MapVC（マップ画面）
    static func backToMapVC(vc: UIViewController, _ updatedUserProfile: User)
    
    // UINavigationを通して戻る
    static func navigationBack(vc: UIViewController)
    // モーダルで戻る
    static func dismissModal(vc: UIViewController, animated: Bool)
}

final class Router {
    
    public static let shared = Router()
    
    private init(){}
    
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
        window.rootViewController = NavigationControllerForAuthVC(rootViewController: authViewController)
        window.makeKeyAndVisible()
    }
    
    // AuthVC（認証画面）→ MapVC（マップ画面）
    static func showMap(vc: UIViewController) {
        let mapViewController = MapViewController()
        let navigationController = NavigationControllerForMapVC(rootViewController: mapViewController)
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        modal(from: vc, to: navigationController)
    }
    
    // MapVC（マップ画面）→ WalkThrough（ウォークスルー画面）
    static func showWalkThoughVC(vc: UIViewController) {
        let walkThroughViewController = WalkThroughViewController()
        walkThroughViewController.modalPresentationStyle = .fullScreen
        modal(from: vc, to: walkThroughViewController)
    }
    
    // MapVC（マップ画面）/ StudyRoomVC（勉強部屋画面）→ ProfileVC（プロフィール画面）
    static func showProfile(vc: UIViewController, with userProfile: User) {
        let profileViewController = ProfileViewController(orientation: orientation(vc), with: userProfile)
        profileViewController.modalPresentationStyle = .overFullScreen
        profileViewController.modalTransitionStyle = .crossDissolve
        modal(from: vc, to: profileViewController)
    }
    
    // ProfileVC（プロフィール画面）→ EditProfileVC（プロフィール編集画面）
    static func showEditProfile(vc: UIViewController, with userProfile: User) {
        let profileViewController = EditProfileViewController(userProfile: userProfile)
        profileViewController.modalPresentationStyle = .overFullScreen
        profileViewController.modalTransitionStyle = .crossDissolve
        modal(from: vc, to: profileViewController)
    }
    
    // MacVC（マップ画面）→ DepartVC（出発画面）
    static func showDepartVC(vc: UIViewController, locationInfo: LocationInfo) {
        let departViewController = DepartViewController()
        departViewController.locationInfo = locationInfo
        departViewController.modalPresentationStyle = .fullScreen
        departViewController.modalTransitionStyle = .crossDissolve
        modal(from: vc, to: departViewController)
    }
    
    // DepartVC（出発画面）→ OnFlightVC（飛行中画面）
    static func showOnFlightVC(vc: UIViewController, locationInfo: LocationInfo) {
        let onFlightViewController = OnFlightViewController()
        onFlightViewController.locationInfo = locationInfo
        onFlightViewController.modalPresentationStyle = .fullScreen
        onFlightViewController.modalTransitionStyle = .crossDissolve
        modal(from: vc, to: onFlightViewController)
    }
    
    // OnFlightVC（飛行中画面）→ StudyRoomVC（勉強部屋画面）
    static func showStudyRoomVC(vc: UIViewController, locationInfo: LocationInfo, userProfiles: [User], latestLoadedDocDate: Timestamp?, oldestDocument: QueryDocumentSnapshot?) {
        let studyRoomViewController = StudyRoomViewController()
        studyRoomViewController.locationInfo = locationInfo
        studyRoomViewController.userProfiles = userProfiles
        studyRoomViewController.latestLoadedDocDate = latestLoadedDocDate
        studyRoomViewController.oldestDocument = oldestDocument
        let navigationController = NavigationControllerForStudyRoomVC(rootViewController: studyRoomViewController)
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        modal(from: vc, to: navigationController)
    }
    
    // StudyRoomVC（勉強部屋画面）→ TicketBackgroundView（チケット確認画面）
    static func showTicketConfirmVC(vc: UIViewController, locationInfo: LocationInfo) {
        let ticketConfirmViewController = TicketConfirmViewController()
        ticketConfirmViewController.locationInfo = locationInfo
        ticketConfirmViewController.modalPresentationStyle = .overFullScreen
        ticketConfirmViewController.modalTransitionStyle = .crossDissolve
        modal(from: vc, to: ticketConfirmViewController)
    }
    
    // StudyRoomVC（勉強部屋画面）→ BackgroundImageSwitchIntervalSelectVC（背景画像切り替えインターバル時間選択画面）
    static func showBackgroundImageSwitchIntervalSelectVC(vc: UIViewController, currentIntervalTime: Int, didIntervalTimeSelect: @escaping (Int) -> Void) {
        let backgroundImageSwitchIntervalSelectVC = BackgroundImageSwitchIntervalSelectViewController()
        backgroundImageSwitchIntervalSelectVC.currentIntervalTime = currentIntervalTime
        backgroundImageSwitchIntervalSelectVC.didIntervalTimeSelect = didIntervalTimeSelect
        backgroundImageSwitchIntervalSelectVC.modalPresentationStyle = .overFullScreen
        backgroundImageSwitchIntervalSelectVC.modalTransitionStyle = .crossDissolve
        modal(from: vc, to: backgroundImageSwitchIntervalSelectVC)
    }
    
    // StudyRoomVC（勉強部屋画面）/ EditProfileVC（プロフィール編集画面）→ MapVC（マップ画面）
    static func backToMapVC(vc: UIViewController, _ updatedUserProfile: User = User()) {
        var nav: NavigationControllerForMapVC!
        
        // 現在の画面がプロフィール編集画面の場合
        if vc is EditProfileViewController,
            let navForMapVC = vc.presentingViewController?.presentingViewController as? NavigationControllerForMapVC, let mapVC = navForMapVC.viewControllers[0] as? MapViewController {
            nav = navForMapVC
            mapVC.userProfile = updatedUserProfile // ユーザープロフィール情報を渡す
        }
        
        // 現在の画面が勉強部屋画面の場合
        else if vc is StudyRoomViewController, let navForMapVC = vc.presentingViewController?.presentingViewController?.presentingViewController as? NavigationControllerForMapVC, let mapVC = navForMapVC.viewControllers[0] as? MapViewController {
            nav = navForMapVC
            mapVC.fromScreen = .studyRoomVC
            // MapVC画面にてデータ再取得を行うため、ユーザープロフィール情報は渡す必要はない
        }
        dismissModal(vc: nav)
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
