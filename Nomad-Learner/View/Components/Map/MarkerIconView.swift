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
    
    // チェックアイコン（完了）
    private let checkmarkImageView: UIImageView = UIImageView().then {
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        $0.image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: configuration)
        $0.tintColor = UIColor(red: 0.0/255.0, green: 100.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 7
    }
    
    // マイナスアイコン（途中）
    private let minusImageView: UIImageView = UIImageView().then {
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        $0.image = UIImage(systemName: "minus.circle.fill", withConfiguration: configuration)
        $0.tintColor = .yellow
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 7
    }
    
    // 人のアイコン
    private let personImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person")
        $0.tintColor = .black
    }
    
    // 勉強中の人数
    private let peopleCountLabel: UILabel = UILabel().then {
        $0.textColor = .black
        $0.text = "20"
        $0.font = .systemFont(ofSize: UIConstants.TextSize.extraSmall)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(markerIconImageView)
        addSubview(checkmarkImageView)
//        addSubview(minusImageView)
//        addSubview(personImageView)
        addSubview(peopleCountLabel)
        
        markerIconImageView.snp.makeConstraints {
            $0.left.top.equalToSuperview()
            $0.size.equalTo(30)
        }
        
        checkmarkImageView.snp.makeConstraints {
            $0.size.equalTo(14)
            $0.left.equalTo(markerIconImageView.snp.right)
            $0.top.equalTo(markerIconImageView)
        }
        
//        minusImageView.snp.makeConstraints {
//            $0.size.equalTo(14)
//            $0.left.equalTo(markerIconImageView.snp.right)
//            $0.top.equalTo(markerIconImageView)
//        }
                
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
