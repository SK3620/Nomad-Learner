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
    }
    
    private lazy var rightLineView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    private lazy var label = UILabel().then {
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: UIConstants.TextSize.semiMedium)
        $0.textAlignment = .center
    }
    
    init(text: String? = nil) {
        super.init(frame: .zero)
        label.text = text
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        axis = .horizontal
        alignment = .center
        distribution = .fillEqually

        addArrangedSubview(leftLineView)
        // 中央にテキストを表示するか否か
        if label.text != nil {
            addArrangedSubview(label)
        }
        addArrangedSubview(rightLineView)
        
        leftLineView.snp.makeConstraints {
            $0.height.equalTo(1.5)
        }
     
        rightLineView.snp.makeConstraints {
            $0.height.equalTo(1.5)
        }
    }
}
