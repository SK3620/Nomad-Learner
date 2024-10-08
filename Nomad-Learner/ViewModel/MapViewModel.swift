//
//  MapViewModel.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/07.
//

import Foundation
import RxSwift
import RxCocoa

class MapViewModel {
    
    // MARK: - Output
    let categories: Driver<[LocationCategoryItem]> = Driver.just(LocationCategoryItem.categories)
    var selectedIndex: Driver<IndexPath> { return selectedCategoryIndex.asDriver(onErrorDriveWith: .empty())}
    
    // タップされたカテゴリーのインデックスを監視、最新の値を保持する
    let selectedCategoryIndex = BehaviorRelay<IndexPath>(value: IndexPath(item: 0, section: 0))
}

extension MapViewModel {
    
}
