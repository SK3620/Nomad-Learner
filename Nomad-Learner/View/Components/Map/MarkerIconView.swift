//
//  MarkerIconView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/18.
//

import UIKit

class MarkerIconView: UIView {
    
    // マーカーアイコン
    private let markerIconImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(systemName: "mountain.2.fill")
        $0.tintColor = .red
    }
    
    // 人のアイコン
    private let personImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person")
        $0.tintColor = .black
    }
    
    // 人数
    private let peopleCountLabel: UILabel = UILabel().then {
        $0.textColor = .black
        $0.text = "20"
        $0.font = .systemFont(ofSize: UIConstants.TextSize.extraSmall)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(markerIconImageView)
//        addSubview(personImageView)
        addSubview(peopleCountLabel)
        
        markerIconImageView.snp.makeConstraints {
            $0.left.top.equalToSuperview()
            $0.size.equalTo(24)
        }
        
//        personImageView.snp.makeConstraints {
//            $0.bottom.equalTo(markerIconImageView.snp.bottom)
//            $0.left.equalTo(markerIconImageView.snp.right)
//            $0.size.equalTo(14)
//        }
        
        peopleCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(markerIconImageView.snp.bottom)
            $0.left.equalTo(markerIconImageView.snp.right)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
