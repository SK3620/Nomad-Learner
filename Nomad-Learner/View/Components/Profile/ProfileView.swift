//
//  ProfileView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/09.
//

import Foundation
import UIKit
import Then
import SnapKit

class ProfileView: UIView {
    
    public let navigationBar: ProfileNavigationBar = ProfileNavigationBar()
    
    public let profileTopView: ProfileTopView = ProfileTopView()
    
    public let profileBottomView: ProfileBottomView = ProfileBottomView()
    
    private let profileTopViewHeight: CGFloat = 80
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 20
        
        addSubview(navigationBar)
        addSubview(profileTopView)
        addSubview(profileBottomView)
        
        navigationBar.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
            $0.height.equalTo(UIConstants.NavigationBar.standardHeight)
        }
        
        profileTopView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(profileTopViewHeight)
        }
        
        profileBottomView.snp.makeConstraints {
            $0.top.equalTo(UIConstants.NavigationBar.standardHeight + profileTopViewHeight + profileTopView.pictureSize / 2)
            $0.right.left.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
