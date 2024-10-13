//
//  NavigationControllerForStudyVCViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/13.
//

import UIKit

// StudyVC用のナビゲーションコントローラークラス
class NavigationControllerForStudyVC: UINavigationController {
    
    // 自動回転の許可を制御
    override var shouldAutorotate: Bool {
        // 現在表示中のビューコントローラーがあれば、その設定に従う
        guard let viewController = self.visibleViewController else { return true }
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