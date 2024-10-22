//
//  MapViewModel.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/07.
//

import Foundation
import RxSwift
import RxCocoa
import Kingfisher

class MapViewModel {
    
    // MARK: - Output
    let categories: Driver<[LocationCategoryItem]> = Driver.just(LocationCategoryItem.categories)
    var selectedIndex: Driver<IndexPath> { return selectedCategoryIndex.asDriver(onErrorDriveWith: .empty())}
    
    let fixedLocations: Driver<[FixedLocation]>
    let isLoading: Driver<Bool>
    let myAppError: Driver<MyAppError>
    
    // タップされたカテゴリーのインデックスを監視、最新の値を保持する
    let selectedCategoryIndex = BehaviorRelay<IndexPath>(value: IndexPath(item: 0, section: 0))
    
    private let mainService: MainServiceProtocol
    private let realmService: RealmServiceProtocol
    
    init(mainService: MainServiceProtocol, realmService: RealmServiceProtocol) {
        self.mainService = mainService
        self.realmService = realmService
        
        // インジケーター
        let indicator = ActivityIndicator()
        self.isLoading = indicator.asDriver()
        
        // マップに配置するロケーション情報取得
        let fetchFixedLocationsResult = realmService.fetchFixedLocations()
            .flatMap { realmData in
                // Realmにデータが存在しない場合Firebaseから取得
                if realmData.isEmpty {
                    return mainService.fetchFixedLocations()
                        .flatMap { firebaseData -> Observable<[FixedLocation]> in
                            // 一旦既存データを削除
                            realmService.deleteFixedLocations()
                            // Firebaseから取得したデータをRealmに保存
                            realmService.saveFixedLocations(firebaseData)
                            // 保存後、取得したデータを流す
                            return Observable.just(firebaseData)
                        }
                        .trackActivity(indicator)
                } else {
                    return Observable.just(realmData)
                }
            }
            .materialize()
            .share(replay: 1)
        
        // 取得したロケーション情報
        self.fixedLocations = fetchFixedLocationsResult
            .compactMap { $0.event.element }
            .map { $0 }
            .asDriver(onErrorJustReturn: [])
        
        // ロケーション情報取得エラー
        let fetchFixedLocationsError = fetchFixedLocationsResult
            .compactMap { $0.event.error as? MyAppError }
        
        // 発生したエラーを一つに集約
        self.myAppError = Observable
            .merge(fetchFixedLocationsError)
            .asDriver(onErrorJustReturn: .unknown)
    }
}
