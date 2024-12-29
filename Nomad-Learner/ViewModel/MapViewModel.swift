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

class MapViewModel {
    
    // MARK: - Output
    // CollectionViewCellに表示するカテゴリー
    let categories: Driver<[LocationCategory]> = Driver.just(LocationCategory.categories)
    // 選択されたカテゴリーのIndexPath
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    
    // 更新保留中の勉強記録データ
    var pendingUpdateData: Driver<(pendingUpdateData: PendingUpdateData?, dataSaveError: MyAppError?)> {
        return self.pendingUpdateDataRelay.asDriver()
    }
    // 更新保留中の勉強記録データ保存/削除完了か否か
    var isPendingUpdateDataHandlingCompleted: Driver<Bool> {
        return self.isPendingUpdateDataHandlingCompletedRelay.asDriver()
    }
    // 各ロケーション情報
    let locationsAndUserInfo: Driver<([LocationInfo], User)>
    // 各ロケーション情報（監視）
    // let monitoredLocationsAndUserInfo: Driver<([LocationInfo], User)>
    // ローディングインジケーター
    let isLoading: Driver<Bool>
    // エラー
    let myAppError: Driver<MyAppError>
    
    // MARK: - Private
    // 各ロケーション情報
    private let locationsAndUserInfoRelay = BehaviorRelay<([LocationInfo], User)?>(value: nil)
    // 更新保留中の勉強記録データの存在有無
    private let pendingUpdateDataRelay = BehaviorRelay<(pendingUpdateData: PendingUpdateData?, dataSaveError: MyAppError?)>(value: (nil, nil))
    // 更新保留中の勉強記録データの保存/削除完了
    private let isPendingUpdateDataHandlingCompletedRelay = BehaviorRelay<Bool>(value: false)
   
    // 全てのロケーション情報を保持
    private static var allLocationsAndUserInfo: ([LocationInfo], User)?
    
    private let realmService: RealmServiceProtocol
    private let mainService: MainServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(
        locationCategoryRelay: BehaviorRelay<LocationCategory>, // カテゴリーを保持
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
        let fetchLocationsAndUserInfoResult = mainService.fetchFixedLocations()
            .flatMap { fixedLocations in
                zip.map { dynamicLocations, visitedLocations, userProfile in
                    let tuple = (fixedLocations, dynamicLocations, visitedLocations, userProfile)
                    let locationsAndUserInfo = MapViewModel.createLocationsInfoAndUserProfile(tuple: tuple)
                    MapViewModel.allLocationsAndUserInfo = locationsAndUserInfo
                    let filteredLocationsAndUserInfo = MapViewModel.filter(locationsAndUserInfo, by: locationCategoryRelay.value)
                    return filteredLocationsAndUserInfo
                }
            }
            .catch { error in // ストリームを終了させない
                myAppErrorRelay.accept(error as? MyAppError )
                return .empty()
            }
            .trackActivity(indicator)
            .materialize()
            .share(replay: 1)
        
        /*
        // 固定ロケーションをリアルタイム監視で取得
        let monitorLocationsInfoResult = mainService.monitorFixedLocationsChanges()
            .skip(1) // 初回起動時、取得した値の整形は行わず、監視の開始のみ実行させる
            .flatMap { fixedLocations in
                zip.map { dynamicLocations, visitedLocations, userProfile in
                    let tuple = (fixedLocations, dynamicLocations, visitedLocations, userProfile)
                    let locationsAndUserInfo = MapViewModel.createLocationsInfoAndUserProfile(tuple: tuple)
                    MapViewModel.allLocationsAndUserInfo = locationsAndUserInfo
                    let filteredLocationsInfo = MapViewModel.filter(locationsAndUserInfo, by: locationCategoryRelay.value)
                    return filteredLocationsInfo
                }
            }
            .materialize()
            .share(replay: 1)
         */
            
        self.locationsAndUserInfo = fetchLocationsAndUserInfoResult
            .compactMap { $0.event.element }
            .asDriver(onErrorJustReturn: ([], User()))
        
        /*
        self.monitoredLocationsAndUserInfo = monitorLocationsInfoResult
            .compactMap { $0.event.element }
            .asDriver(onErrorJustReturn: ([], User()))
         */
        
        // ロケーション情報取得完了後にRealmから更新保留中の勉強記録データを取得
        fetchLocationsAndUserInfoResult
            .compactMap { $0.event.element }
            .concatMap { _ in realmService.fetchPendingUpdateData() }
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] pendingUpdateData in
                self?.pendingUpdateDataRelay.accept((pendingUpdateData, dataSaveError: nil))
            })
            .disposed(by: disposeBag)
    }
}

extension MapViewModel {
    // 共通処理 取得データの整形
    private static func createLocationsInfoAndUserProfile(tuple: ([FixedLocation], [DynamicLocation], [VisitedLocation], User)) -> ([LocationInfo], User) {
        let (fixedLocations, dynamicLocations, visitedLocations, userProfile) = tuple
        
        // 全てのキャッシュのクリア
        ImageCacheManager.clearCache()
        // 各ロケーションの最初の画像のみプリフェッチ
        let imageUrls = fixedLocations.compactMap(\.imageUrls.first).compactMap(URL.init)
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
    
    // カテゴリーで絞り込み
    public static func filter(
        _ allLocationsAndUserInfo: ([LocationInfo], User)? = MapViewModel.allLocationsAndUserInfo,
        by category: LocationCategory
    ) -> ([LocationInfo], User) {
        guard let (locationsInfo, userProfile) = allLocationsAndUserInfo,
              let myLocationsInfo = locationsInfo.getCurrentLocationInfo(with: userProfile.currentLocationId) else {
            return ([], User())
        }
        // 現在地のロケーション情報を取得
        // 絞り込み結果
        var filteredLocationsInfo: [LocationInfo] = []
        switch category {
        case .all:
            return (locationsInfo, userProfile)
        case .buildings, .nature:
            filteredLocationsInfo = locationsInfo.filter { $0.fixedLocation.category.contains(category.rawValue) }
        case .hasntVisited:
            filteredLocationsInfo = locationsInfo.filter { !$0.locationStatus.isCompleted && !$0.locationStatus.isOngoing }
        case .isOngoing:
            filteredLocationsInfo = locationsInfo.filter { $0.locationStatus.isOngoing }
        case .isCompleted:
            filteredLocationsInfo = locationsInfo.filter { $0.locationStatus.isCompleted }
        }
        // 現在地のロケーション情報も含める
        return (filteredLocationsInfo + [myLocationsInfo], userProfile)
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
                    self?.pendingUpdateDataRelay.accept((pendingUpdateData, .savePendingUpdateDataFailed(error)))
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
    
    /*
    // 固定ロケーションの更新の監視を解除
    func removeObserverForFixedLocationsChanges() {
        mainService.removeObserver()
    }
     */
}
