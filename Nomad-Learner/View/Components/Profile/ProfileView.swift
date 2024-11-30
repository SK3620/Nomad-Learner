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
    
    var userProfile: User
    
    var orientation: ScreenOrientation
    
    let navigationBar: ProfileNavigationBar = ProfileNavigationBar()
    
    lazy var profileTopView: ProfileTopView = ProfileTopView(userProfile: self.userProfile)
    
    lazy var profileBottomView: ProfileBottomView = ProfileBottomView(orientation: self.orientation, with: self.userProfile)
    
    private let profileTopViewHeight: CGFloat = 80
    
    init(orientation: ScreenOrientation, with userProfile: User) {
        self.userProfile = userProfile
        self.orientation = orientation
        super.init(frame: .zero)
        
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
            $0.height.equalTo(44)
        }
        
        profileTopView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(profileTopViewHeight)
        }
        
        profileBottomView.snp.makeConstraints {
            $0.top.equalTo(44 + profileTopViewHeight + profileTopView.pictureSize / 2)
            $0.right.left.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
