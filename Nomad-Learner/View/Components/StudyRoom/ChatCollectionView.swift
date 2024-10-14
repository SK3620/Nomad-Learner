//
//  ChatCollectionView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/13.
//

import UIKit
import SnapKit

class ChatCollectionView: UICollectionView {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        // self-sizing有効化 セルのサイズはセルの内容に応じて動的に変化させる
        layout.estimatedItemSize = CGSizeMake(1.0, 1.0)
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.backgroundColor = .clear
        self.showsHorizontalScrollIndicator = true
        self.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: ChatCollectionViewCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
