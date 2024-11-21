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

class MapViewModel {
    
    // MARK: - Output
    let categories: Driver<[LocationCategoryItem]> = Driver.just(LocationCategoryItem.categories)
    var selectedIndex: Driver<IndexPath> { return selectedCategoryIndexRelay.asDriver(onErrorDriveWith: .empty())}
    
    // 更新保留中の勉強記録データ
    var pendingUpdateData: Driver<(pendingUpdateData: PendingUpdateData?, saveRetryError: MyAppError?)> {
        self.pendingUpdateDataRelay.asDriver()
    }
    // 更新保留中の勉強記録データ保存/削除完了か否か
    var isPendingUpdateDataHandlingCompleted: Driver<Bool> {
        self.isPendingUpdateDataHandlingCompletedRelay.asDriver()
    }
    // 絞り込み検索結果
//    let filteredLocationsInfo: Driver<LocationsInfo>

    let locationsAndUserInfo: Driver<(LocationsInfo, User)> // 各ロケーション情報
    let monitoredLocationsAndUserInfo: Driver<(LocationsInfo, User)> // 各ロケーション情報
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
        mainService: MainServiceProtocol,
        realmService: RealmServiceProtocol
    ) {
        self.mainService = mainService
        self.realmService = realmService
        
        // エラーを流す
        let myAppErrorRelay = BehaviorRelay<MyAppError?>(value: nil)
        
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
        
        // マップに配置するロケーション情報を流す
        self.locationsAndUserInfo = fetchLocationsInfoResult
            .compactMap { $0.event.element }
            .asDriver(onErrorJustReturn: (LocationsInfo(), User()))
        
        // マップに配置するロケーション情報を流す（監視）
        self.monitoredLocationsAndUserInfo = monitorLocationsInfoResult
            .compactMap { $0.event.element }
            .asDriver(onErrorJustReturn: (LocationsInfo(), User()))
        
        // 発生したエラーを一つに集約
        self.myAppError = myAppErrorRelay
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: .unknown)
        
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
    private static func createLocationsInfoAndUserProfile(tuple: ([FixedLocation], [DynamicLocation], [VisitedLocation], User)) -> (LocationsInfo, User) {
        let (fixedLocations, dynamicLocations, visitedLocations, userProfile) = tuple
        
        // キャッシュのクリアと画像のプリフェッチ
        ImageCacheManager.clearCache()
        let imageUrls = fixedLocations.flatMap(\.imageUrlsArr).compactMap(URL.init)
        ImageCacheManager.prefetch(from: imageUrls)
        
        // プロフィール画像をプリフェッチ（空の場合はスキップ）
        if !userProfile.profileImageUrl.isEmpty {
            ImageCacheManager.prefetch(from: [URL(string: userProfile.profileImageUrl)!])
        }
        
        for fixedLocation in fixedLocations {
            let dynamicLocation = dynamicLocations.first(where: { $0.locationId == fixedLocation.locationId })
            let visitedLocation = visitedLocations.first(where: { $0.locationId == fixedLocation.locationId })
            
            
        }
        
        /*
        var mutableUserProfile = userProfile
        var locationsInfo = LocationsInfo(
            fixedLocations: fixedLocations,
            dynamicLocations: dynamicLocations,
            visitedLocations: visitedLocations
        )
        
        let ticketsInfo = MapViewModel.createTicketsInfo(userProfile: userProfile, locationsInfo: locationsInfo)
        let locationsStatus = MapViewModel.createLocationStatus(currentLocationId: userProfile.currentLocationId, ticketsInfo: ticketsInfo, locationsInfo: locationsInfo)
        let progressSum = MapViewModel.createStudyProgressSummary(fixedLocations: fixedLocations, visitedLocations: visitedLocations, locationsStatus: locationsStatus)
        
        locationsInfo = LocationsInfo(
            fixedLocations: fixedLocations,
            dynamicLocations: dynamicLocations,
            visitedLocations: visitedLocations,
            ticketsInfo: ticketsInfo,
            locationStatus: locationsStatus
        )
        
        mutableUserProfile.progressSum = progressSum
        return (locationsInfo, mutableUserProfile)
         */
    }
}

extension MapViewModel {
    func getFilteredLocationsInfo() {
        
    }
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
            mainService.removeUserIdFromLocation(locationId: pendingUpdateData.locationId)
                .subscribe(onDisposed: { [weak self] in // 全てのイベントを検知
                    self?.realmService.deletePendingUpdateData() // Realmからデータ削除
                    self?.isPendingUpdateDataHandlingCompletedRelay.accept(true)
                })
                .disposed(by: disposeBag)
        }
    }
}

extension MapViewModel {
    // 各ロケーションごとに、チケットの各UIに表示する情報を配列で生成
    private static func createTicketsInfo(
        userProfile: User,
        locationsInfo: LocationsInfo
    ) -> [TicketInfo] {
        // ユーザーの現在の所持金を取得
        let currentCoin = userProfile.currentCoin
        // 固定ロケーション取得
        let fixedLocations = locationsInfo.fixedLocations
        // ユーザーの現在地のロケーション情報取得
        let currentLocationInfo = fixedLocations.first(where: { $0.locationId == userProfile.currentLocationId })!
        // ユーザーの現在地のロケーションの座標取得
        let currentLocationCoordinate = CLLocationCoordinate2D(
            latitude: currentLocationInfo.latitude,
            longitude: currentLocationInfo.longitude
        )
        
        // チケットの各UIに表示する情報を格納
        var ticketsInfo: [TicketInfo] = []
        for fixedLocation in fixedLocations {
            // マップ上の各固定ロケーションの座標を取得
            let fixedLocationCoordinate = CLLocationCoordinate2D(latitude: fixedLocation.latitude, longitude: fixedLocation.longitude)
            
            // チケット情報構造体を生成
            let ticketInfo = TicketInfo(
                coordinate: (
                    from: currentLocationCoordinate,
                    to: fixedLocationCoordinate
                ),
                locationDetials: locationsInfo.getLocationDetailsForTicketInfo(for: fixedLocation.locationId),
                currentCoin: currentCoin, 
                currentCountry: currentLocationInfo.country
            )
            // 配列に格納
            ticketsInfo.append(ticketInfo)
        }
        return ticketsInfo
    }
    
    // 各ロケーションごとの状態を配列で生成
    private static func createLocationStatus(
        currentLocationId: String,
        ticketsInfo: [TicketInfo],
        locationsInfo: LocationsInfo
    ) -> [LocationStatus] {
        // 固定ロケーション取得
        let fixedLocations = locationsInfo.fixedLocations
        // 訪問情報を取得
        let visitedLocations = locationsInfo.visitedLocations
        
        var locationsStatus: [LocationStatus] = []
        for fixedLocation in fixedLocations {
            // 参加人数を取得
            let userCount = locationsInfo.dynamicLocations.first(where: { $0.locationId == fixedLocation.locationId })?.userCount ?? 0
            // 固定ロケーションIDを取得
            let fixedLocationId = fixedLocation.locationId
            // 過去に訪問したロケーションかどうか
            let hasVisited = visitedLocations.contains(where: { $0.locationId == fixedLocationId })
            // チケット情報を取得
            let ticketInfo = ticketsInfo.first(where: { $0.locationId == fixedLocationId })!
            // 所持金が足りてるか否か
            let isSufficientCoin = ticketInfo.currentCoin >= ticketInfo.travelDistanceAndCost
            // 現在地か否か
            let isMyCurrentLocation = currentLocationId == fixedLocationId
            // 訪問履歴がある && 必要な合計勉強時間をクリアしているか否か
            let isCompleted = hasVisited && ticketInfo.totalStudyHours >= ticketInfo.requiredStudyHours
            // 訪問履歴がある && 必要な合計勉強時間に到達していないか否か（進行中か否か）
            let isOngoing = hasVisited && ticketInfo.totalStudyHours < ticketInfo.requiredStudyHours
            // 初期位置か否か
            let isInitialLocation = fixedLocation.locationId == MyAppSettings.userInitialLocationId
            
            // ロケーション状態構造体を生成
            let locationStatus = LocationStatus(
                locationId: fixedLocationId,
                userCount: userCount,
                isSufficientCoin: isSufficientCoin,
                isMyCurrentLocation: isMyCurrentLocation,
                isCompleted: isCompleted,
                isOngoing: isOngoing,
                isInitialLocation: isInitialLocation
            )
            // 配列に格納
            locationsStatus.append(locationStatus)
        }
        return locationsStatus
    }
    
    private static func createStudyProgressSummary(
        fixedLocations: [FixedLocation],
        visitedLocations: [VisitedLocation],
        locationsStatus: [LocationStatus]
    ) -> StudyProgressSummary {
        return StudyProgressSummary(
            fixedLocations: fixedLocations,
            visitedLocations: visitedLocations,
            locationsStatus: locationsStatus
        )
    }
}
