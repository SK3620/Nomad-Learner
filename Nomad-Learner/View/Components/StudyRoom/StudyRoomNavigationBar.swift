//
//  StudyRoomNavigationBar.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/13.
//

import UIKit
import SnapKit
import Then

class StudyRoomNavigationBar: UIView {
    
    // ナビゲーションバーレイアウト変更ボタン
    private let switchLayoutButton = UIButton().then {
        $0.setImage(UIImage(systemName: "repeat"), for: .normal)
        $0.tintColor = ColorCodes.primaryPurple.color()
    }
    
    // 合計時間ラベル
    private let timeLabel: UILabel = UILabel().then {
        $0.text = "合計時間 01:38:45"
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .black
    }
    
    // メニュー表示ボタン
    private let ellipsisButton = UIButton().then {
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        $0.tintColor = ColorCodes.primaryPurple.color()
        $0.showsMenuAsPrimaryAction = true
    }
    
    // 現在地ラベル
    private let currentPositionLabel: UILabel = UILabel().then {
        $0.text = "The Great Barrier Reef / United Kingdom / South West England"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .gray
    }
    
    // 現在地ラベルスクロールビュー
    private lazy var currentPositionScrollView: UIScrollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        // スクロール範囲
        $0.contentSize.width = self.currentPositionLabel.contentSizeHeight()
        $0.isHidden = true
    }
    
    // UIMenuを生成
    private lazy var menu: UIMenu = {
        let breakAction = UIAction(title: "休憩", image: UIImage(systemName: "cup.and.saucer")) { _ in
            print("休憩")
        }
        let exitAction = UIAction(title: "退出", image: UIImage(systemName: "door.left.hand.open")) { _ in
            print("退出")
        }
        let communityAction = UIAction(title: "コミュニティ", image: UIImage(systemName: "person.3")) { _ in
            print("コミュニティ")
        }
        return UIMenu(title: "", children: [breakAction, exitAction, communityAction])
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // ナビゲーションバーにアイテムを設定
    private func setupUI() {
        backgroundColor = .clear
        
        // ビューに各要素を追加
        addSubview(switchLayoutButton)
        addSubview(timeLabel)
        currentPositionScrollView.addSubview(currentPositionLabel)
        addSubview(currentPositionScrollView)
        addSubview(ellipsisButton)
        
        // レイアウトの設定
        switchLayoutButton.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        timeLabel.snp.makeConstraints {
            $0.left.equalTo(switchLayoutButton.snp.right).offset(UIConstants.Layout.standardPadding)
            $0.centerY.equalToSuperview()
        }
        
//        currentPositionScrollView.snp.makeConstraints {
//            $0.left.equalTo(switchLayoutButton.snp.right).offset(UIConstants.Layout.standardPadding)
//            $0.centerY.equalToSuperview()
//            $0.height.equalToSuperview()
//            $0.width.equalTo(200)
//        }
        
        currentPositionLabel.backgroundColor = .red
        currentPositionScrollView.backgroundColor = .green
        
        ellipsisButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        // メニューを設定
        ellipsisButton.menu = menu
    }
}
