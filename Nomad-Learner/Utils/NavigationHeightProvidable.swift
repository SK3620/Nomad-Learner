//
//  NavigationHeightProvidable.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/06.
//

import Foundation
import UIKit

/// ステータスバーやナビゲーションバー、ツールバー、TabBarの高さを提供するプロトコル
public protocol NavigationHeightProvidableProtocol {
    static var statusBarHeight: CGFloat { get }
    static func navigationBarHeight(navigationController: UINavigationController?) -> CGFloat
    static func totalTopBarHeight(navigationController: UINavigationController?) -> CGFloat
    static func toolbarHeight(navigationController: UINavigationController?) -> CGFloat
    static func tabBarHeight(tabBarController: UITabBarController?) -> CGFloat
}

/// プロトコルに準拠したデフォルトの実装を提供する拡張
final class NavigationHeightProvidable: NavigationHeightProvidableProtocol {
    
    /// ステータスバーの高さを取得
    static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }
    
    /// ナビゲーションバーの高さを取得
    /// - Parameter navigationController: 対象のナビゲーションコントローラー
    /// - Returns: ナビゲーションバーの高さ（存在しない場合は0）
    static func navigationBarHeight(navigationController: UINavigationController?) -> CGFloat {
        return navigationController?.navigationBar.frame.height ?? 0
    }
    
    /// ステータスバー + ナビゲーションバーの高さの合計を取得
    /// - Parameter navigationController: 対象のナビゲーションコントローラー
    /// - Returns: 合計の高さ
    static func totalTopBarHeight(navigationController: UINavigationController?) -> CGFloat {
        return statusBarHeight + navigationBarHeight(navigationController: navigationController)
    }
    
    /// ツールバーの高さを取得
    /// - Parameter navigationController: 対象のナビゲーションコントローラー
    /// - Returns: ツールバーの高さ（存在しない場合は0）
    static func toolbarHeight(navigationController: UINavigationController?) -> CGFloat {
        return navigationController?.toolbar.frame.height ?? 0
    }
    
    /// TabBarの高さを取得
    /// - Parameter tabBarController: 対象のTabBarコントローラー
    /// - Returns: TabBarの高さ（存在しない場合は0）
    static func tabBarHeight(tabBarController: UITabBarController?) -> CGFloat {
        return tabBarController?.tabBar.frame.height ?? 0
    }
}
