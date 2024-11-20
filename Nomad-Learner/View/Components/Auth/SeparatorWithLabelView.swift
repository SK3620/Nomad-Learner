//
//  SeparatorWithLabelView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/09/29.
//

import UIKit
import SnapKit
import Then

import UIKit
import SnapKit

class SeparatorWithLabelView: UIStackView {
    
    private lazy var leftLineView = UIView().then {
        $0.backgroundColor = .lightGray
        $0.snp.makeConstraints {
            $0.height.equalTo(1.5)
        }
    }
    
    private lazy var rightLineView = UIView().then {
        $0.backgroundColor = .lightGray
        $0.snp.makeConstraints {
            $0.height.equalTo(1.5)
        }
    }
    
    private lazy var label = UILabel().then {
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textAlignment = .center
    }
    
    init(text: String? = nil) {
        super.init(frame: .zero)
        axis = .horizontal
        alignment = .center
        distribution = .fillEqually
        label.text = text
        
        setupUI()
    }
    
    private func setupUI() {
        addArrangedSubview(leftLineView)
        // 中央にテキストを表示するか否か
        if label.text != nil {
            addArrangedSubview(label)
        }
        addArrangedSubview(rightLineView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
