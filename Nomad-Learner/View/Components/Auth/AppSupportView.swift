//
//  AppSupportView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/12/05.
//

import Foundation
import UIKit
import SnapKit
import Then

class AppSupportView: UIView {
    
    let tapGesture = UITapGestureRecognizer()
    
    let contactButton = UIButton(type: .system).then {
        $0.setTitle("お問合せフォーム", for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.tintColor = ColorCodes.primaryPurple.color()
    }
    
    let privacyPolicyButton = UIButton(type: .system).then {
        $0.setTitle("プライバシーポリシー", for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.tintColor = ColorCodes.primaryPurple.color()
    }
    
    let termsAndConditionsButton = UIButton(type: .system).then {
        $0.setTitle("利用規約", for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.tintColor = ColorCodes.primaryPurple.color()
    }
    
    let backButton = UIButton(type: .system).then {
        $0.setTitle("閉じる", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.tintColor = UIColor.red
    }
    
    let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            contactButton,
            privacyPolicyButton,
            termsAndConditionsButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = ColorCodes.modalBackground.color()
        
        self.addGestureRecognizer(tapGesture)
        
        addSubview(containerView)
        containerView.addSubview(stackView)
        containerView.addSubview(backButton)
        
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
        
        stackView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(backButton.snp.top).offset(-40)
        }
        
        backButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }
}
