//
//  ScreenSizeProvidable.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/13.
//

import UIKit

/// SafeAreaと画面サイズに関するプロトコル
public protocol ScreenSizeProvidableProtocol: SafeAreaHeightProvidableProtocol {
    static func screenWidth(viewController: UIViewController?) -> CGFloat
    static func screenHeight(viewController: UIViewController?) -> CGFloat
    static func totalHeightWithSafeArea(viewController: UIViewController?) -> CGFloat
}

/// SafeAreaと画面サイズのデフォルト実装を提供するクラス
final class ScreenSizeProvidable: ScreenSizeProvidableProtocol {
    
    // SafeAreaHeightProvidableProtocolの実装
    static func topSafeAreaHeight(viewController: UIViewController?) -> CGFloat {
        return viewController?.view.safeAreaInsets.top ?? 0
    }
    
    static func bottomSafeAreaHeight(viewController: UIViewController?) -> CGFloat {
        return viewController?.view.safeAreaInsets.bottom ?? 0
    }
    
    static func totalSafeAreaHeight(viewController: UIViewController?) -> CGFloat {
        return topSafeAreaHeight(viewController: viewController) + bottomSafeAreaHeight(viewController: viewController)
    }
    
    // ScreenSizeProvidableProtocolの追加実装
    static func screenWidth(viewController: UIViewController?) -> CGFloat {
        return viewController?.view.frame.width ?? UIScreen.main.bounds.width
    }
    
    static func screenHeight(viewController: UIViewController?) -> CGFloat {
        return viewController?.view.frame.height ?? UIScreen.main.bounds.height
    }
    
    static func totalHeightWithSafeArea(viewController: UIViewController?) -> CGFloat {
        let screenHeight = screenHeight(viewController: viewController)
        let totalSafeAreaHeight = totalSafeAreaHeight(viewController: viewController)
        return screenHeight - totalSafeAreaHeight
    }
}

