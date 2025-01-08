//
//  NavigationControllerForMapVC.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/16.
//

import UIKit

// MapVC用のナビゲーションコントローラー
class NavigationControllerForMapVC: UINavigationController {
    
    // 自動回転の許可を制御
    override var shouldAutorotate: Bool {
        // 現在表示中のビューコントローラーがあれば、その設定に従う
        guard let viewController = self.visibleViewController else { return false }
        return viewController.shouldAutorotate
    }
    
    // サポートする画面の向きを制御
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        // 現在表示中のビューコントローラーがあれば、その設定に従う
        guard let viewController = self.visibleViewController else { return .portrait }
        return viewController.supportedInterfaceOrientations
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
