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
import GoogleMaps

enum DataHandlingType {
    case initialFetch      // 初回の自動取得
    case manualReload      // リロードボタンで取得
    case listenerTriggered // リアルタイムリスナーで取得
    case fetchWithRewardAlert //　データ取得後にアラート表示
}

enum LocationCategory: String, CaseIterable {
    case all = "all"
    case mountain = "moutain"
    case sea = "sea"
    case library = "library"
    case museum = "museum"
    case architecture = "architecture"
    case waterfall = "waterfall"

    // カテゴリ一覧を取得
    static var categories: [LocationCategory] {
        return Array(self.allCases)
    }
}

class MapViewModel {
    
    // MARK: - Output
    let categories: Driver<[LocationCategoryItem]> = Driver.just(LocationCategoryItem.categories)
    var selectedIndex: Driver<IndexPath> { return selectedCategoryIndexRelay.asDriver(onErrorDriveWith: .empty())}
    
    // 更新保留中の勉強記録データ
    var pendingUpdateData: Driver<(pendingUpdateData: PendingUpdateData?, saveRetryError: MyAppError?)> {
        return self.pendingUpdateDataRelay.asDriver()
    }
    // 更新保留中の勉強記録データ保存/削除完了か否か
    var isPendingUpdateDataHandlingCompleted: Driver<Bool> {
        return self.isPendingUpdateDataHandlingCompletedRelay.asDriver()
    }
    
    let locationsAndUserInfo: Driver<([LocationInfo], User)> // 各ロケーション情報
    let monitoredLocationsAndUserInfo: Driver<([LocationInfo], User)> // 各ロケーション情報
    let isLoading: Driver<Bool> // ローディングインジケーター
    let myAppError: Driver<MyAppError> // エラー
    
    // MARK: - Input
    // 更新保留中の勉強記録データの存在有無
    let pendingUpdateDataRelay = BehaviorRelay<(pendingUpdateData: PendingUpdateData?, saveRetryError: MyAppError?)>(value: (nil, nil))
    // 更新保留中の勉強記録データの保存/削除完了
    let isPendingUpdateDataHandlingCompletedRelay = BehaviorRelay<Bool>(value: false)
    // タップされたカテゴリーのインデックスを監視、最新の値を保持する
    let selectedCategoryIndexRelay = BehaviorRelay<IndexPath>(value: IndexPath(item: 0, section: 0))
    
    private let realmService: RealmServiceProtocol
    private let mainService: MainServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(
        locationCategoryRelay: BehaviorRelay<LocationCategory>,
        mainService: MainServiceProtocol,
        realmService: RealmServiceProtocol
    ) {
        self.mainService = mainService
        self.realmService = realmService
        
        // エラーを流す
        let myAppErrorRelay = BehaviorRelay<MyAppError?>(value: nil)
        // 発生したエラーを一つに集約
        self.myAppError = myAppErrorRelay
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: .unknown)
        
        // インジケーター
        let indicator = ActivityIndicator()
        self.isLoading = indicator.asDriver()
        
        let zip = Observable.zip(
            mainService.fetchLocations(),
            mainService.fetchVisitedLocations(),
            mainService.fetchUserProfile()
        )
        
        // マップに配置するロケーション関連の情報取得
        let fetchLocationsInfoResult = mainService.fetchFixedLocations()
            .flatMap { fixedLocations in
                zip.map { dynamicLocations, visitedLocations, userProfile in
                    let tuple = (fixedLocations, dynamicLocations, visitedLocations, userProfile)
                    return MapViewModel.createLocationsInfoAndUserProfile(tuple: tuple)
                }
            }
            .catch { error in // ストリームを終了させない
                myAppErrorRelay.accept(error as? MyAppError )
                return .empty()
            }
            .trackActivity(indicator)
            .materialize()
            .share(replay: 1)
        
        // 固定ロケーションをリアルタイム監視で取得
        let monitorLocationsInfoResult = mainService.monitorFixedLocationsChanges()
            .skip(1) // 初回起動時、取得した値の整形は行わない
            .flatMap { fixedLocations in
                zip.map { dynamicLocations, visitedLocations, userProfile in
                    let tuple = (fixedLocations, dynamicLocations, visitedLocations, userProfile)
                    return MapViewModel.createLocationsInfoAndUserProfile(tuple: tuple)
                }
            }
            .materialize()
            .share(replay: 1)
        /*
        // マップに配置するロケーション情報を流す
//        self.locationsAndUserInfo = fetchLocationsInfoResult
//            .compactMap { $0.event.element }
//            .asDriver(onErrorJustReturn: ([], User()))
        
//        self.locationsAndUserInfo = fetchLocationsInfoResult
//            .compactMap { $0.event.element } // エラーでないことを確認
//            .flatMap { locationsAndUserInfo in
//                Observable.combineLatest( // 選択されているカテゴリーで絞り込み
//                    Observable.just(locationsAndUserInfo),
//                    locationCategoryRelay
//                ) { locationsAndUserInfo, category in
//                    let (locationsInfo, userProfile) = locationsAndUserInfo
//                    let filteredLocationsInfo = locationsInfo.filter { $0.fixedLocation.category == category.rawValue }
//                    return (filteredLocationsInfo, userProfile)
//                }
//            }
//            .asDriver(onErrorJustReturn: ([], User()))
            
        // マップに配置するロケーション情報を流す（監視）
//        self.monitoredLocationsAndUserInfo = monitorLocationsInfoResult
//            .compactMap { $0.event.element }
//            .asDriver(onErrorJustReturn: ([], User()))
//        
//        self.monitoredLocationsAndUserInfo = monitorLocationsInfoResult
//            .compactMap { $0.event.element } // エラーでないことを確認
//            .flatMap { locationsAndUserInfo in
//                Observable.combineLatest( // 選択されているカテゴリーで絞り込み
//                    Observable.just(locationsAndUserInfo),
//                    locationCategoryRelay
//                ) { locationsAndUserInfo, category in
//                    let (locationsInfo, userProfile) = locationsAndUserInfo
//                    let filteredLocationsInfo = locationsInfo.filter { $0.fixedLocation.category == category.rawValue }
//                    return (filteredLocationsInfo, userProfile)
//                }
//            }
//            .asDriver(onErrorJustReturn: ([], User()))
         */
        // 選択されているカテゴリーで絞り込み（共通処理）
        let filterLocationsInfoByCategory = { (locationsInfoResult: Observable<Event<([LocationInfo], User)>>) -> Driver<([LocationInfo], User)> in
            locationsInfoResult
                .compactMap { $0.event.element }
                .flatMap { locationsAndUserInfo in
                    Observable.combineLatest(
                        Observable.just(locationsAndUserInfo),
                        locationCategoryRelay
                    ) { locationsAndUserInfo, category in
                        // .allの場合は全てのロケーション情報を流す
                        guard category != .all else { return locationsAndUserInfo }
                        let (locationsInfo, user) = locationsAndUserInfo
                        let filteredLocationsInfo = locationsInfo.filter { $0.fixedLocation.category == category.rawValue }
                        return (filteredLocationsInfo, user)
                    }
                }
                .asDriver(onErrorJustReturn: ([], User()))
        }
        
        // マップに配置するロケーション情報を流す
        self.locationsAndUserInfo = filterLocationsInfoByCategory(fetchLocationsInfoResult)
        // マップに配置するロケーション情報を流す（監視）
        self.monitoredLocationsAndUserInfo = filterLocationsInfoByCategory(monitorLocationsInfoResult)
        
        // ロケーション情報取得完了後にRealmから更新保留中の勉強記録データを取得
        fetchLocationsInfoResult
            .compactMap { $0.event.element }
            .concatMap { _ in realmService.fetchPendingUpdateData() }
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] pendingUpdateData in
                self?.pendingUpdateDataRelay.accept((pendingUpdateData, saveRetryError: nil))
            })
            .disposed(by: disposeBag)
    }
}

extension MapViewModel {
    // 共通処理 取得データの整形
    private static func createLocationsInfoAndUserProfile(tuple: ([FixedLocation], [DynamicLocation], [VisitedLocation], User)) -> ([LocationInfo], User) {
        let (fixedLocations, dynamicLocations, visitedLocations, userProfile) = tuple
        
        // キャッシュのクリアと画像のプリフェッチ
        ImageCacheManager.clearCache()
        let imageUrls = fixedLocations.flatMap(\.imageUrls).compactMap(URL.init)
        ImageCacheManager.prefetch(from: imageUrls)
        
        // プロフィール画像をプリフェッチ（空の場合はスキップ）
        if !userProfile.profileImageUrl.isEmpty {
            ImageCacheManager.prefetch(from: [URL(string: userProfile.profileImageUrl)!])
        }
        
        var mutableUserProfile = userProfile
        let progressSum = StudyProgressSummary(
            fixedLocations: fixedLocations,
            visitedLocations: visitedLocations
        )
        mutableUserProfile.progressSum = progressSum
        
        // ユーザーの現在地のロケーション情報取得
        let currentLocationInfo = fixedLocations.first(where: { $0.locationId == userProfile.currentLocationId })!
        
        var locationsInfo: [LocationInfo] = []
        for fixedLocation in fixedLocations {
            let visitedLocation = visitedLocations.first(where: { $0.locationId == fixedLocation.locationId })
            let dynamicLocation = dynamicLocations.first(where: { $0.locationId == fixedLocation.locationId })
            
            let ticketInfo = TicketInfo(
                currentCoin: userProfile.currentCoin,
                currentLocationInfo: currentLocationInfo,
                fixedLocation: fixedLocation,
                visitedLocation: visitedLocation
            )
            
            let locationStatus = LocationStatus(
                currentLocationId: userProfile.currentLocationId,
                fixedLocation: fixedLocation,
                visitedLocation: visitedLocation,
                dynamicLocation: dynamicLocation,
                ticketInfo: ticketInfo
            )
            
            let locationInfo = LocationInfo(
                locationId: fixedLocation.locationId,
                fixedLocation: fixedLocation,
                dynamicLocation: dynamicLocation,
                visitedLocation: visitedLocation,
                ticketInfo: ticketInfo,
                locationStatus: locationStatus
            )
            locationsInfo.append(locationInfo)
        }
        return (locationsInfo, mutableUserProfile)
    }
}

extension MapViewModel {
    // 更新保留中の勉強記録データの保存/削除
    func handlePendingUpdateData(pendingUpdateData: PendingUpdateData, shouldSave: Bool = true) {
        // データの整形
        let visitedLocationToUpdate = pendingUpdateData.toVisitedLocation
        let locationId = visitedLocationToUpdate.locationId
        let addedRewardCoin = pendingUpdateData.addedRewardCoin
        
        if shouldSave {
            // 保存処理
            let combinedObservableResult = Observable.zip(
                mainService.removeUserIdFromLocation(locationId: locationId),
                mainService.saveStudyProgressAndRewards(locationId: locationId, updatedData: visitedLocationToUpdate),
                mainService.updateCurrentCoin(addedRewardCoin: addedRewardCoin)
            )
                .catch { [weak self] error in
                    self?.pendingUpdateDataRelay.accept((pendingUpdateData, .savePendingUpdateDataRetryFailed(error)))
                    return .empty()
                }
            
            combinedObservableResult
                .subscribe(onNext: { [weak self] _, _, _ in
                    self?.realmService.deletePendingUpdateData() // Realmからデータ削除
                    self?.isPendingUpdateDataHandlingCompletedRelay.accept(true)
                })
                .disposed(by: disposeBag)
        } else {
            // 削除処理
            mainService.removeUserIdFromLocation(locationId: pendingUpdateData.locationId)
                .subscribe(onDisposed: { [weak self] in // 全てのイベントを検知
                    self?.realmService.deletePendingUpdateData() // Realmからデータ削除
                    self?.isPendingUpdateDataHandlingCompletedRelay.accept(true)
                })
                .disposed(by: disposeBag)
        }
    }
}
