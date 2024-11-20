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
    var mapItem = MapTabBarItem(name: "map")
    
    // レポートボタン
    var reportItem = MapTabBarItem(name: "doc.plaintext", color: .lightGray)
    
    // 飛行機（出発）ボタン
    var airplaneItem = MapTabBarItem(name: "airplane", color: .white).then {
        $0.backgroundColor = ColorCodes.primaryPurple.color()
        $0.layer.cornerRadius = 44 / 2
        // 縦向きの飛行機に調整
        $0.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) * 2 * 270 / 360)
        $0.applyShadow(color: .black, opacity: 0.6, offset: CGSize(width: 0.5, height: 4), radius: 5)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 70 / 2
        self.backgroundColor = .white
        self.applyShadow(color: .black, opacity: 0.3, offset: CGSize(width: 1, height: 1), radius: 3)
        
        setupUI()
    }
    
    private func setupUI() {
        
        addSubview(mapItem)
        addSubview(airplaneItem)
        addSubview(reportItem)
        
        mapItem.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(44)
            $0.right.equalTo(airplaneItem.snp.left).offset(-40)
        }
        mapItem.imageView!.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        airplaneItem.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-4)
        }
        airplaneItem.imageView!.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        reportItem.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(44)
            $0.left.equalTo(airplaneItem.snp.right).offset(40)
        }
        reportItem.imageView!.snp.makeConstraints {
            $0.size.equalTo(24)
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


