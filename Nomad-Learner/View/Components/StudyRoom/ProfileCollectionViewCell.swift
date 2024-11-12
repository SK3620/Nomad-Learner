//
//  ProfileCollectionViewCell.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/13.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProfileCollectionViewCell"
    
    // プロフィール画像
    private let profileImageView: UIImageView = UIImageView().then {
        $0.backgroundColor = .orange
        $0.layer.cornerRadius = 15.0
        $0.layer.masksToBounds = true
    }
    
    // 名前
    private let userNameLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: UIConstants.TextSize.semiMedium)
        $0.textColor = .black
        $0.numberOfLines = 1
        $0.text = "User Name Here"
    }
    
    // 内容
    private let contentLabel: UILabel = UILabel().then {
        $0.textColor = .black
        $0.numberOfLines = 3
        $0.sizeToFit()
        $0.font = .systemFont(ofSize: UIConstants.TextSize.extraSmall, weight: .ultraLight)
        $0.text = "senior/Certified Public Accountant/TOEFL®: Test of English as a Foreign Language/IELTS: International English Language Testing System"
    }
    
    // 国旗画像
    private let nationalFlagImageView: UIImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = ColorCodes.primaryPurple.color()
        $0.layer.cornerRadius = 15.0
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI(){
        backgroundColor = UIColor(white: 1.0, alpha: 0.7)
        layer.cornerRadius = 15.0
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(nationalFlagImageView)
        
        // プロフィール画像
        profileImageView.snp.makeConstraints {
            $0.left.equalTo(contentView.snp.left).offset(UIConstants.Layout.smallPadding)
            $0.verticalEdges.equalToSuperview().inset(UIConstants.Layout.smallPadding)
            $0.width.equalTo(contentView.snp.height).offset(-(UIConstants.Layout.smallPadding * 2))
        }

        // 名前
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top)
            $0.left.equalTo(profileImageView.snp.right).offset(UIConstants.Layout.smallPadding)
            $0.right.equalTo(nationalFlagImageView.snp.left).offset(-UIConstants.Layout.smallPadding)
        }

        // 内容
        contentLabel.snp.makeConstraints {
            $0.left.equalTo(userNameLabel.snp.left)
            $0.top.equalTo(userNameLabel.snp.bottom)
            $0.right.equalToSuperview().offset(-UIConstants.Layout.smallPadding)
        }

        // 国旗
        nationalFlagImageView.snp.makeConstraints {
            $0.right.top.equalToSuperview()
            $0.width.equalTo(30)
            $0.height.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileCollectionViewCell {
    
    public func configure(with userProfile: User) {
        if userProfile.profileImageUrl.isEmpty {
            profileImageView.image = UIImage(named: "Globe") // 空の場合はデフォルト画像
        } else {
            profileImageView.setImage(with: userProfile.profileImageUrl)
        }
        
        let content = "\(userProfile.livingPlaceAndWork) / \(userProfile.studyContent) / \(userProfile.goal)"
        userNameLabel.text = userProfile.username
        contentLabel.text = content
    }
}
