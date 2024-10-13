//
//  NavigationControllerForStudyVCViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/13.
//

import UIKit

// StudyVC用のナビゲーションコントローラークラス
class NavigationControllerForStudyVC: UINavigationController {
    
    // ナビゲーションバーレイアウト変更ボタン
    private let switchLayoutButton = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.backward"), style: .plain, target: nil, action: nil)
    
    // 合計時間ラベル
    private let timeLabel: UILabel = UILabel().then {
        $0.text = "合計時間 01:38:45"
        $0.font = .systemFont(ofSize: UIConstants.TextSize.medium)
        $0.textColor = .black
    }
        
    // 合計時間ラベルをcustomViewとして表示
    private lazy var timeLabelItem: UIBarButtonItem = {
        let item = UIBarButtonItem(customView: self.timeLabel)
        item.customView?.isUserInteractionEnabled = false
        return item
    }()
    
    // 現在地ラベル
    private let currentPositionLabel: UILabel = UILabel().then {
        $0.text = "The Great Barrier Reef / United Kingdom / South West England"
    }
    
    // 現在地ラベルスクロールビュー
    private lazy var currentPositionScrollView: UIScrollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        // スクロール範囲
        $0.contentSize.width = currentPositionLabel.contentSizeWidth()
        $0.snp.makeConstraints {
            $0.height.equalTo(currentPositionLabel.contentSizeHeight())
            $0.width.equalTo(250)
        }
    }
    
    // メニュー表示ボタン
    private let ellipsisButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: nil, action: nil)
    
    // メニュー内の休憩ボタン
    private lazy var breakAction = UIAction(title: "休憩", image: UIImage(systemName: "cup.and.saucer")) { [weak self] _ in
        print("休憩")
    }
    
    // メニュー内の退出ボタン
    private lazy var exitAction = UIAction(title: "退出", image: UIImage(systemName: "door.left.hand.open")) { [weak self] _ in
        print("退出")
    }
    
    // メニュー内のコミュニティボタン
    private lazy var communityAction = UIAction(title: "コミュニティ", image: UIImage(systemName: "person.3")) { [weak self] _ in
        print("コミュニティ")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // ナビゲーションバーにアイテムを設定
    private func setupUI() {
        // UIMenuを生成
        let menu = UIMenu(title: "", children: [breakAction, exitAction, communityAction])
        ellipsisButton.menu = menu
        
        // 複数のアイテムを左寄せで配置
        topViewController?.navigationItem.leftBarButtonItems = [switchLayoutButton, timeLabelItem, ellipsisButton]
    }
}

extension NavigationControllerForStudyVC {
    
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
}
