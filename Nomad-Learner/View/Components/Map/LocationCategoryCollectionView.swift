//
//  LocationCategoryCollectionView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/08.
//

import UIKit

import UIKit

class LocationCategoryCollectionView: UICollectionView {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.backgroundColor = .white
        self.showsHorizontalScrollIndicator = false
        self.layer.cornerRadius = 30
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LocationCategoryCollectionView {
    
    // タップされたアイテム位置へスクロール
    func scrollToCenter(indexPath: IndexPath) {
        scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
