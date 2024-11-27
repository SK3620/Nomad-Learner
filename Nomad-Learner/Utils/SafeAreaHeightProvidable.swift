//
//  SafeAreaHeightProvidable.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/12.
//

import Foundation
import UIKit

/// safeAreaの高さを提供するプロトコル
public protocol SafeAreaHeightProvidableProtocol {
    static func topSafeAreaHeight(viewController: UIViewController?) -> CGFloat
    static func bottomSafeAreaHeight(viewController: UIViewController?) -> CGFloat
    static func totalSafeAreaHeight(viewController: UIViewController?) -> CGFloat
}

/// プロトコルに準拠したデフォルトの実装を提供するクラス
final class SafeAreaHeightProvidable: SafeAreaHeightProvidableProtocol {
    
    /// 上部の safeArea の高さを取得
    /// - Parameter viewController: 対象のビューコントローラー
    /// - Returns: 上部 safeArea の高さ
    static func topSafeAreaHeight(viewController: UIViewController?) -> CGFloat {
        return viewController?.view.safeAreaInsets.top ?? 0
    }
    
    /// 下部の safeArea の高さを取得
    /// - Parameter viewController: 対象のビューコントローラー
    /// - Returns: 下部 safeArea の高さ
    static func bottomSafeAreaHeight(viewController: UIViewController?) -> CGFloat {
        return viewController?.view.safeAreaInsets.bottom ?? 0
    }
    
    /// 上部 + 下部の safeArea の高さの合計を取得
    /// - Parameter viewController: 対象のビューコントローラー
    /// - Returns: safeArea の高さの合計
    static func totalSafeAreaHeight(viewController: UIViewController?) -> CGFloat {
        let top = topSafeAreaHeight(viewController: viewController)
        let bottom = bottomSafeAreaHeight(viewController: viewController)
        return top + bottom
    }
}
