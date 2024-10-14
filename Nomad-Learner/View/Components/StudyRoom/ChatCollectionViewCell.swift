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
        
    private var disposeBag = DisposeBag()
    
    //
    private let profileImageView: UIImageView = UIImageView().then {
        $0.layer.cornerRadius = 32 / 2
        $0.backgroundColor = .orange
    }
    
    private let usernameLabel: UILabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = .black
        $0.font = .systemFont(ofSize: UIConstants.TextSize.small)
    }
        
    private let contentLabel: PaddingLabel = PaddingLabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: UIConstants.TextSize.small, weight: .light)
        $0.backgroundColor = UIColor(white: 1.0, alpha: 0.7)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        // テキストに余白を空ける
        let edgeInset: CGFloat = UIConstants.Layout.smallPadding
        $0.padding = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
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
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(contentLabel)
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIConstants.Layout.semiStandardPadding)
            $0.left.equalToSuperview().inset(UIConstants.Layout.smallPadding)
            $0.size.equalTo(32)
        }
        
        usernameLabel.snp.makeConstraints {
            $0.bottom.equalTo(profileImageView)
            $0.left.equalTo(profileImageView.snp.right).offset(UIConstants.Layout.extraSmallPadding)
            $0.right.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.left.equalTo(profileImageView.snp.centerX)
            $0.top.equalTo(profileImageView.snp.bottom).offset(UIConstants.Layout.extraSmallPadding)
            $0.bottom.right.equalToSuperview()
        }
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatCollectionViewCell {
    
    public func configure(with item: Message, maxWidth: CGFloat) {
        usernameLabel.text = item.senderName
        contentLabel.text = item.content
        
        // contentLabelの使用可能な最大横幅
        contentLabel.preferredMaxLayoutWidth = maxWidth
        
    }
    /*
    // ViewModelへのバインディング
    func bind(indexPath: IndexPath, viewModel: MapViewModel) {
        categoryButtonTaps
            .emit(onNext: {
                viewModel.selectedCategoryIndex.accept(indexPath)
            })
            .disposed(by: disposeBag)
    }
     */
}
