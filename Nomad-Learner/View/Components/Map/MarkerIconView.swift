//
//  MarkerIconView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/18.
//

import UIKit

class MarkerIconView: UIView {
    
    private let statusIcon = StatusIcon()
    
    private struct StatusIcon {
        // アイコン画像
        let hasntVisited = UIImage(named: "MapPinGray") // 未訪問
        let ongoing = UIImage(named: "MapPinYellow") // 進行中
        let completed = UIImage(named: "MapPinGreen") // 達成
    }
    
    // ロケーションのピン
    private let locationPinImageView = UIImageView()
    
    // 勉強中の人数
    private let userCountLabel: UILabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: UIConstants.TextSize.small)
    }
    
    init(frame: CGRect, locationStatus: LocationStatus) {
        super.init(frame: frame)
        
        setupUI(isMyCurrentLocation: locationStatus.isMyCurrentLocation)
        // 各UIを更新
        update(locationStatus: locationStatus)
    }
    
    private func setupUI(isMyCurrentLocation: Bool) {
        addSubview(locationPinImageView)
        addSubview(userCountLabel)
      
        locationPinImageView.snp.makeConstraints {
            $0.bottom.centerX.equalToSuperview()
            $0.size.equalTo(28)
        }
        
        userCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(locationPinImageView.snp.top).inset(4) // 微調整
            $0.centerX.equalToSuperview()
        }
    }
    
    private func update(locationStatus: LocationStatus) {
        // 参加人数
        userCountLabel.text = locationStatus.userCount.toString
        
        // 初期位置の場合は現在地ピンのみ表示
        let isInitialLocation = locationStatus.isInitialLocation
        locationPinImageView.isHidden = isInitialLocation
        userCountLabel.isHidden = isInitialLocation
        
        // 必要な合計勉強時間をクリアしている場合
        if locationStatus.isCompleted {
            locationPinImageView.image = statusIcon.completed
        }
        // 進行中の場合
        else if locationStatus.isOngoing {
            locationPinImageView.image = statusIcon.ongoing
        }
        // まだ訪問したことがない場合
        else {
            locationPinImageView.image = statusIcon.hasntVisited
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
