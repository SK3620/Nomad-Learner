//
//  ChatCollectionViewCell.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/13.
//

import UIKit
import RxSwift
import RxCocoa

class ChatCollectionViewCell: UICollectionViewCell {
    static let identifier = "ChatCollectionViewCell"
    
    let profileImageViewHeight: CGFloat = 32
    let edgesSpacing: CGFloat = 10
    let spacing: CGFloat = 6
    
    private var disposeBag = DisposeBag()
    
    private lazy var profileImageView = UIImageView().then {
        $0.layer.cornerRadius = self.profileImageViewHeight / 2
        $0.backgroundColor = .orange
    }
    
    private let usernameLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 14)
    }
    
    private let contentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    // セルが再利用されるたびにDisposeBagを新たに初期化 重複購読を防ぐ
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func setupUI() {
        layer.cornerRadius = 10
        contentView.layer.cornerRadius = 10
        backgroundColor = UIColor(white: 1.0, alpha: 0.7)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(contentLabel)
        
        profileImageView.snp.makeConstraints {
            $0.left.top.equalToSuperview().inset(edgesSpacing)
            $0.size.equalTo(profileImageViewHeight)
        }
        
        usernameLabel.snp.makeConstraints {
            $0.left.equalTo(profileImageView.snp.right).offset(4)
            $0.centerY.equalTo(profileImageView)
            $0.right.equalToSuperview().inset(edgesSpacing)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(spacing)
            $0.horizontalEdges.equalToSuperview().inset(edgesSpacing)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatCollectionViewCell {
    func configure(with item: Message) {
        usernameLabel.text = item.senderName
        contentLabel.text = item.content
    }
}
