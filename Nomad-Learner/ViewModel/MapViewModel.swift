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
    
    let fixedLocations: Driver<[FixedLocation]> // マップ上にマーカーとして配置するロケーション
    let userProfile: Driver<User> // ユーザープロフィール
    let visitedLocations: Driver<[VisitedLocation]> // 訪問したロケーション情報
    let isLoading: Driver<Bool>
    let myAppError: Driver<MyAppError>
    
    // タップされたカテゴリーのインデックスを監視、最新の値を保持する
    let selectedCategoryIndex = BehaviorRelay<IndexPath>(value: IndexPath(item: 0, section: 0))
    
    init(mainService: MainServiceProtocol, realmService: RealmServiceProtocol) {
        
        // インジケーター
        let indicator = ActivityIndicator()
        self.isLoading = indicator.asDriver()
        
        // マップに配置するロケーション情報取得
        let fetchFixedLocationsResult = realmService.fetchFixedLocations()
            .flatMap { realmData in
                // Realmにデータが存在しない場合Firebaseから取得
                if realmData.isEmpty {
                    return mainService.fetchFixedLocations()
                        .flatMap { fixedLocations -> Observable<[FixedLocation]> in
                            // 一旦既存データを削除
                            realmService.deleteFixedLocations()
                            // Firebaseから取得したデータをRealmに保存
                            realmService.saveFixedLocations(fixedLocations)
                            // マップ上に配置するロケーション画像のURLをプリフェッチ
                            let imageUrls = fixedLocations.flatMap(\.imageUrlsArr).compactMap(URL.init)
                            ImageCacheManager.prefetch(from: imageUrls)
                            // 保存後、取得したデータを流す
                            return Observable.just(fixedLocations)
                        }
                        .trackActivity(indicator)
                } else {
                    return Observable.just(realmData)
                }
            }
            .materialize()
            .share(replay: 1)
        
        // 取得したロケーション情報を流す
        self.fixedLocations = fetchFixedLocationsResult
            .compactMap { $0.event.element }
            .map { $0 }
            .asDriver(onErrorJustReturn: [])
        
        // ロケーション情報取得エラーを流す
        let fetchFixedLocationsError = fetchFixedLocationsResult
            .compactMap { $0.event.error as? MyAppError }
        
        // ユーザープロフィールと訪問したロケーションの取得を同時に行う
        let mergedObservable = Observable.zip(
            mainService.fetchUserProfile(), // ユーザープロフィールの取得
            mainService.fetchVisitedLocations() // 訪問したロケーションの取得
        )
            .materialize()
            .trackActivity(indicator)
            .share(replay: 1)
        
        // ユーザープロフィールを流す
        self.userProfile = mergedObservable
            .compactMap { event in
                guard case .next((let userProfile, _)) = event else {
                    return nil
                }
                // プロフィール画像をプリフェッチ 空の場合はデフォルト画像を適用
                if !userProfile.profileImageUrl.isEmpty {
                    ImageCacheManager.prefetch(from: [URL(string: userProfile.profileImageUrl)!])
                }
                return userProfile
            }
            .asDriver(onErrorJustReturn: User())
        
        // 訪問したロケーション情報を流す
        self.visitedLocations = mergedObservable
            .compactMap { event in
                guard case .next((_, let visitedLocations)) = event else {
                    return nil
                }
                return visitedLocations
            }
            .asDriver(onErrorJustReturn: [])
        
        // ユーザープロフィールまたはロケーション取得のエラーを流す
        let mergedObservableError = mergedObservable
            .compactMap { $0.event.error as? MyAppError }
        
        // 発生したエラーを一つに集約
        self.myAppError = Observable
            .merge(fetchFixedLocationsError, mergedObservableError)
            .asDriver(onErrorJustReturn: .unknown)
    }
}
