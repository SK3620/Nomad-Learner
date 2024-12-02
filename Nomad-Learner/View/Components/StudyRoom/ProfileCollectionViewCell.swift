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
        $0.backgroundColor = ColorCodes.primaryLightPurple.color()
        $0.layer.cornerRadius = 15.0
        $0.layer.borderWidth = 1
        $0.layer.borderColor = ColorCodes.primaryPurple.color().cgColor
        $0.layer.masksToBounds = true
    }
    
    // 名前
    private let userNameLabel: UILabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = .black
        $0.numberOfLines = 1
    }
    
    // 内容
    private let contentLabel: UILabel = UILabel().then {
        $0.textColor = .black
        $0.numberOfLines = 3
        $0.sizeToFit()
        $0.font = .systemFont(ofSize: 12)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.kf.cancelDownloadTask()
        profileImageView.image = nil
    }
    
    private func setupUI(){
        backgroundColor = UIColor(white: 1.0, alpha: 0.7)
        layer.cornerRadius = 15.0
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(contentLabel)
        
        // プロフィール画像
        profileImageView.snp.makeConstraints {
            $0.left.equalTo(contentView.snp.left).offset(8)
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.width.equalTo(contentView.snp.height).offset(-8 * 2)
        }

        // 名前
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top)
            $0.left.equalTo(profileImageView.snp.right).offset(8)
            $0.right.equalToSuperview().inset(8)
        }

        // 内容
        contentLabel.snp.makeConstraints {
            $0.left.equalTo(userNameLabel.snp.left)
            $0.top.equalTo(userNameLabel.snp.bottom).offset(3) // 微調整
            $0.right.equalToSuperview().offset(-8)
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
            profileImageView.setImage(with: userProfile.profileImageUrl, options: [.keepCurrentImageWhileLoading])
        }
        
        let content = "\(userProfile.studyContent) / \(userProfile.goal) / \(userProfile.others)"
        userNameLabel.text = userProfile.username
        contentLabel.text = content
    }
}
