//
//  StudyRoomView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/13.
//

import UIKit

class ProfileCollectionView: UICollectionView {
    // cellの縦間隔
    private let verticalGap: CGFloat = 12
    // cellの横間隔
    private let horizontalGap: CGFloat = 28
    // 右側に余白を空けてスクロールインジケーターと被らないようにする
    private let edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
    
    private var layout: UICollectionViewFlowLayout
    
    init() {
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = verticalGap // 各セルの垂直間隔（行間）
        layout.minimumInteritemSpacing = horizontalGap // 各セルの水平間隔（列間）
        layout.sectionInset = edgeInsets // セクション全体の内側余白（上下左右のマージン）
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // profileCollectionViewのframeの値確定後、itemSizeを更新
    public func updateItemSize(size: CGSize) {
        // cellの横間隔を除くcellの合計幅
        let cellTotalWidth = size.width - (horizontalGap + edgeInsets.right)
        // cellの縦間隔を除くcellの合計高さ
        let cellTotalHeight = size.height - verticalGap * 4
        // itemSize を設定 画面に横に2列、縦に4列のcellを表示
        layout.itemSize = CGSize(width: cellTotalWidth / 2, height: cellTotalHeight / 4)
        // レイアウトを更新
        layout.invalidateLayout()
    }
}

