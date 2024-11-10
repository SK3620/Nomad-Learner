//
//  MarkerIconView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/18.
//

import UIKit

class MarkerIconView: UIView {
    
    private var statusIcon = StatusIcon()
    
    private struct StatusIcon {
        // アイコン画像
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        lazy var completed = UIImage(systemName: "checkmark.circle.fill", withConfiguration: self.configuration)
        lazy var ongoing = UIImage(systemName: "minus.circle.fill", withConfiguration: self.configuration)
        var hasNotVisided = UIImage()
        
        // アイコン色
        let completedColor = UIColor(red: 0.0/255.0, green: 100.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        let ongoingColor = UIColor.yellow
        
        // アイコン背景色
        let completedBackgroundColor = UIColor.white
        let ongoingBackgroundColor = UIColor.black
    }
    
    // マーカーアイコン
    private let markerIconImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(systemName: "mountain.2.fill")
        $0.tintColor = .red
    }
    
    // 現在地ピン
    private let mappinImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(systemName: "mappin")
        $0.tintColor = ColorCodes.primaryPurple.color()
    }
    
    // ステータスアイコン（完了/進行中/未訪問）
    private let statusImageView: UIImageView = UIImageView().then {
        $0.layer.cornerRadius = 7
    }

    // 人のアイコン
    private let personImageView: UIImageView = UIImageView().then {
        let configuration = UIImage.SymbolConfiguration(weight: .medium)
        $0.image = UIImage(systemName: "person", withConfiguration: configuration)
        $0.tintColor = .black
    }
    
    // 勉強中の人数
    private let userCountLabel: UILabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: UIConstants.TextSize.extraSmall)
    }
    
    
    init(frame: CGRect, locationStatus: LocationStatus) {
        super.init(frame: frame)
        
        setupUI(isMyCurrentLocation: locationStatus.isMyCurrentLocation)
        // 各UIを更新
        update(locationStatus: locationStatus)
    }
    
    private func setupUI(isMyCurrentLocation: Bool) {
        addSubview(markerIconImageView)
        if isMyCurrentLocation {
            addSubview(mappinImageView)
            addSubview(personImageView)
        }
        addSubview(statusImageView)
        addSubview(userCountLabel)
        
        markerIconImageView.snp.makeConstraints {
            $0.left.top.equalToSuperview()
            $0.size.equalTo(30)
        }
        
        if isMyCurrentLocation {
            mappinImageView.snp.makeConstraints {
                $0.left.top.equalToSuperview()
                $0.size.equalTo(30)
            }
            personImageView.snp.makeConstraints {
                $0.bottom.equalTo(markerIconImageView.snp.bottom)
                $0.left.equalTo(markerIconImageView.snp.right)
                $0.size.equalTo(14)
            }
        }
        
        statusImageView.snp.makeConstraints {
            $0.size.equalTo(14)
            $0.left.equalTo(markerIconImageView.snp.right)
            $0.top.equalTo(markerIconImageView)
        }
        
        userCountLabel.snp.makeConstraints {
            $0.bottom.equalTo(markerIconImageView).offset(2) // 微調整
            $0.left.equalTo(isMyCurrentLocation ? personImageView.snp.right : markerIconImageView.snp.right)
        }
    }
    
    private func update(locationStatus: LocationStatus) {
        // 参加人数
        userCountLabel.text = locationStatus.userCount.toString
        
        // 必要な合計勉強時間をクリアしている場合
        if locationStatus.isCompleted {
            statusImageView.image = statusIcon.completed
            statusImageView.tintColor = statusIcon.completedColor
            statusImageView.backgroundColor = statusIcon.completedBackgroundColor
        }
        // 進行中の場合
        else if locationStatus.isOngoing {
            statusImageView.image = statusIcon.ongoing
            statusImageView.tintColor = statusIcon.ongoingColor
            statusImageView.backgroundColor = statusIcon.ongoingBackgroundColor
        }
        // まだ訪問したことがない場合
        else {
            statusImageView.image = statusIcon.hasNotVisided
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
