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
    let switchLayoutButton = UIButton().then {
        $0.setImage(UIImage(systemName: "repeat"), for: .normal)
        $0.tintColor = ColorCodes.primaryPurple.color()
        $0.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
        $0.layer.cornerRadius = 26 / 2
    }
    
    // メニュー表示ボタン
    private let ellipsisButton = UIButton().then {
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        $0.tintColor = ColorCodes.primaryPurple.color()
        $0.showsMenuAsPrimaryAction = true
        $0.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
        $0.layer.cornerRadius = 26 / 2
    }
    
    // 合計時間ラベル
    private let timeLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 14)
        $0.textColor = .black
    }
    
    // 現在地ラベル
    private let currentPositionLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 14)
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .black
    }
    
    // 現在地ラベルスクロールビュー
    private lazy var currentPositionScrollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        // スクロール範囲
        $0.contentSize.width = self.currentPositionLabel.contentSizeHeight()
        $0.addSubview(currentPositionLabel)
    }
    
    private lazy var backgroundViewForTimeAndPositionLabel = UIView().then {
        $0.backgroundColor = .init(white: 1.0, alpha: 0.4)
        $0.layer.cornerRadius = 26 / 2
        $0.addSubview(timeLabel)
        $0.addSubview(currentPositionScrollView)
    }
    
    // UIMenuを生成
    private lazy var menuActions: [UIAction] = {
        let breakAction = UIAction(title: "休憩", image: UIImage(systemName: "cup.and.saucer")) { _ in
            self.menuActionHandler?((.breakTime))
        }
        let confirmTicketAction =  UIAction(title: "チケット", image: UIImage(systemName: "ticket")) { _ in
            self.menuActionHandler?((.confirmTicket))
        }
        let changeBackgroundImageSwitchIntervalTimeAction = UIAction(title: "画像切り替え", image: UIImage(systemName: "photo.stack")) { _ in
            self.menuActionHandler?((.changeBackgroundImageSwitchIntervalTime))
        }
        let communityAction = UIAction(title: "コミュニティ", image: UIImage(systemName: "person.3")) { _ in
            self.menuActionHandler?((.community))
        }
        let exitAction = UIAction(title: "終了", image: UIImage(systemName: "door.left.hand.open")?.withTintColor(.red), attributes: .destructive) { _ in
            self.menuActionHandler?((.exitRoom))
        }
        
        return [breakAction, confirmTicketAction, changeBackgroundImageSwitchIntervalTimeAction, communityAction, exitAction]
    }()
    
    // UIActionでのメニュー選択通知用のクロージャ
    var menuActionHandler: ((StudyRoomViewModel.MenuAction) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(switchLayoutButton)
        addSubview(ellipsisButton)
        addSubview(backgroundViewForTimeAndPositionLabel)
                
        switchLayoutButton.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(26)
        }
        
        ellipsisButton.snp.makeConstraints {
            $0.left.equalTo(switchLayoutButton.snp.right).offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(26)
        }
        
        backgroundViewForTimeAndPositionLabel.snp.makeConstraints {
            $0.left.equalTo(ellipsisButton.snp.right).offset(16)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(26)
        }
                
        timeLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        currentPositionScrollView.snp.makeConstraints {
            $0.left.equalTo(timeLabel.snp.right).offset(16)
            $0.centerY.equalToSuperview()
            $0.height.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
        }
        
        currentPositionLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        // ellipsisボタンにメニューを設定
        ellipsisButton.menu = UIMenu(title: "", children: menuActions)
    }
}

extension StudyRoomNavigationBar {
    // UIを更新
    func update(fixedLocation: FixedLocation) {
        let locationText = "\(fixedLocation.location) / \(fixedLocation.country) / \(fixedLocation.region)"
        currentPositionLabel.text = locationText
    }
    
    // タイマーを更新
    func updateTimer(timerText: String) {
        timeLabel.text = timerText
    }
    
    // 休憩中 または 勉強再開 を交互に切り替える
    func switchBreakOrRestartAction(_ action: StudyRoomViewModel.MenuAction = .restart) {
        let actionInfo: (title: String, image: UIImage)
        
        switch action {
        case .breakTime:
            actionInfo = ("再開", UIImage(systemName: "restart")!)
        case .restart:
            actionInfo = ("休憩", UIImage(systemName: "cup.and.saucer")!)
        default:
            return
        }
        
        let breakOrRestartAction = UIAction(
            title: actionInfo.title,
            image: actionInfo.image,
            handler: { [weak self] _ in
                guard let self = self else { return }
                let newAction: StudyRoomViewModel.MenuAction = (action == .breakTime) ? .restart : .breakTime
                self.menuActionHandler?(newAction)
            }
        )
        // 休憩中or勉強再開メニューボタンを挿入し、新しいメニューを設定
        menuActions.remove(at: 0)
        menuActions.insert(breakOrRestartAction, at: 0)
        ellipsisButton.menu = UIMenu(title: "", children: menuActions)
    }
}
