//
//  ProfileBottomView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/09.
//

import Foundation
import UIKit
import Then
import SnapKit

class ProfileBottomView: UIView {
    
    var userProfile: User
    
    // profileTableViewのアニメーション時のデフォルト位置
    private var defaultPositionY: CGFloat = CGFloat()
    
    // 名前
    private let usernameLabel: ProfileLabel = ProfileLabel(text: "Peder Elias", fontSize: UIConstants.TextSize.semiLarge, textColor: .darkGray)
    
    // インフォメーションアイコンボタン（開発中の機能）
    let inDevelopmentButton = UIButton().then {
        $0.setImage(UIImage(systemName: "info.circle"), for: .normal)
        $0.imageView?.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
    
    // 区切り線
    private let borderView: UIView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    // 詳細な自己紹介
    private var profileTableView: UITableView = UITableView().then {
        $0.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        $0.layer.borderColor = UIColor.clear.cgColor
        $0.separatorColor = .clear
        $0.allowsSelection = false
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    init(userProfile: User) {
        self.userProfile = userProfile
        
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        layer.masksToBounds = true
        
        setupUI()
        update(with: userProfile)
    }
    
    private func setupUI() {
        addSubview(usernameLabel)
        addSubview(inDevelopmentButton)
        addSubview(borderView)
        addSubview(profileTableView)
        
        usernameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIConstants.Layout.smallPadding)
            $0.left.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            $0.right.equalTo(inDevelopmentButton.snp.left)
        }
        
        inDevelopmentButton.snp.makeConstraints {
            $0.top.centerY.equalTo(usernameLabel)
            $0.right.equalToSuperview().inset(16)
        }
        
        borderView.snp.makeConstraints {
            $0.top.equalTo(usernameLabel.snp.bottom).offset(UIConstants.Layout.smallPadding)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        profileTableView.snp.makeConstraints {
            $0.top.equalTo(borderView.snp.bottom)
            $0.right.left.bottom.equalToSuperview()
        }
        self.profileTableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifer)
        profileTableView.delegate = self
        profileTableView.dataSource = self
    }
    
    // ユーザープロフィール情報を受け取り、UI更新
    private func update(with userProfile: User) {
        usernameLabel.text = userProfile.username
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.defaultPositionY = self.frame.origin.y
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileBottomView: UITableViewDelegate, UITableViewDataSource {
    
    // 固定で一行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifer, for: indexPath) as! ProfileTableViewCell
        cell.studyContent.text = userProfile.studyContent
        cell.goal.text = userProfile.goal
        cell.others.text = userProfile.others
        return cell
    }
    
    // スクロール位置に応じて、表示するTableViewを伸縮させる
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        
        // スクロール位置が0未満の場合は固定
        if offset < 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            adjustConstraintsForNegativeOffset()
        } else if offset >= 30 {
            adjustConstraintsForPositiveOffset()
        }
    }
    
    // 上にスクロールした場合の制約調整
    private func adjustConstraintsForNegativeOffset() {
        // usernameLabelの制約を更新
        self.usernameLabel.snp.remakeConstraints {
            $0.top.equalToSuperview().inset(UIConstants.Layout.smallPadding)
            $0.left.equalToSuperview().inset(UIConstants.Layout.standardPadding)
        }
        
        // ProfileBottomViewの制約を更新
        self.snp.remakeConstraints {
            $0.top.equalToSuperview().inset(defaultPositionY)
            $0.right.left.bottom.equalToSuperview()
        }
    }
    
    // 下にスクロールした場合の制約調整
    private func adjustConstraintsForPositiveOffset() {
        // ProfileBottomViewの制約を更新
        self.snp.remakeConstraints {
            $0.top.equalToSuperview().inset(UIConstants.NavigationBar.standardHeight)
            $0.right.left.bottom.equalToSuperview()
        }
        
        // usernameLabelの制約を更新
        self.usernameLabel.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(UIConstants.Layout.smallPadding)
        }
    }
}
