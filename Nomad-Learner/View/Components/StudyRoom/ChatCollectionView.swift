//
//  ChatCollectionView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/13.
//

import UIKit
import SnapKit

class ChatCollectionView: UICollectionView {
    // cellの縦間隔
    private let verticalGap: CGFloat = 16
    // セクション全体の内側余白（上下左右のマージン）
    private let edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 4)
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = verticalGap
        layout.sectionInset = edgeInsets
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.backgroundColor = .clear
        self.showsHorizontalScrollIndicator = true
        self.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: ChatCollectionViewCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
