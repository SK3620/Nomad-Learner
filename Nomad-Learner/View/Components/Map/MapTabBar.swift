//
//  MapTabBar.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/06.
//

import Foundation
import UIKit
import Then
import SnapKit

class MapTabBar: UIView {
    
    // マップボタン
    private lazy var mapItem: UIButton = MapTabBarItem(name: "map")
    
    // 飛行機（出発）ボタン
    private lazy var airplaneItem: UIButton = MapTabBarItem(name: "airplane", color: .white).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
        $0.layer.cornerRadius = UIConstants.Button.height / 2
        // 縦向きの飛行機に調整
        $0.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) * 2 * 270 / 360)
        // 影を追加
        $0.applyShadow(
            color: .black,
            opacity: 0.6,
            offset: CGSize(width: 0.5, height: 4),
            radius: 5
        )
    }
    
    // レポートボタン
    private lazy var reportItem: UIButton = MapTabBarItem(name: "doc.plaintext")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = UIConstants.TabBarHeight.height / 2
        self.backgroundColor = .white
        // 影を追加
        self.applyShadow(color: .black, opacity: 0.3, offset: CGSize(width: 1, height: 1), radius: 3)
        
        setupUI()
    }
    
    private func setupUI() {
        
        addSubview(mapItem)
        addSubview(airplaneItem)
        addSubview(reportItem)
        
        mapItem.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(UIConstants.Button.height)
            $0.right.equalTo(airplaneItem.snp.left).offset(-(UIConstants.Layout.extraLargePadding))
        }
        mapItem.imageView!.snp.makeConstraints {
            $0.size.equalTo(UIConstants.Image.size)
        }
        
        airplaneItem.snp.makeConstraints {
            $0.size.equalTo(UIConstants.Button.height)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-(UIConstants.Layout.extraSmallPadding))
        }
        airplaneItem.imageView!.snp.makeConstraints {
            $0.size.equalTo(UIConstants.Image.size)
        }
        
        reportItem.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(UIConstants.Button.height)
            $0.left.equalTo(airplaneItem.snp.right).offset(UIConstants.Layout.extraLargePadding)
        }
        reportItem.imageView!.snp.makeConstraints {
            $0.size.equalTo(UIConstants.Image.size)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MapTabBarItem: UIButton {
    
    init(name: String, color: UIColor = ColorCodes.primaryPurple.color()) {
        super.init(frame: .zero)
        
        setImage(UIImage(systemName: name), for: .normal)
        tintColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


