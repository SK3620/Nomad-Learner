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
    let categories: Driver<[LocationCategoryItem]> = Driver.just(LocationCategoryItem.categories)
    var selectedIndex: Driver<IndexPath> { return selectedCategoryIndex.asDriver(onErrorDriveWith: .empty())}
    
    let locationsAndUserInfo: Driver<(LocationsInfo, User)> // 各ロケーション情報
    let isLoading: Driver<Bool> // ローディングインジケーター
    let myAppError: Driver<MyAppError> // エラー
    
    // MARK: - Input
    // タップされたカテゴリーのインデックスを監視、最新の値を保持する
    let selectedCategoryIndex = BehaviorRelay<IndexPath>(value: IndexPath(item: 0, section: 0))
    
    init(
        mainService: MainServiceProtocol,
        realmService: RealmServiceProtocol
    ) {
        
        // インジケーター
        let indicator = ActivityIndicator()
        self.isLoading = indicator.asDriver()
        
        // マップに配置するロケーション関連の情報取得
        //（イベント発火＋マップマーカーViewの再描画）が高頻度で行われると予想されるため、
        // firebaseによる値の監視（リスナー）はしない
        let fetchLocationsInfoResult = realmService.fetchFixedLocations() // Realmから固定ロケーション取得
            .flatMap { realmData in
                // Realmにデータがない場合、Firebaseから取得してキャッシュ
                let locationData = realmData.isEmpty
                ? mainService.fetchFixedLocations()
                    .do(onNext: { fixedLocations in
                    // 既存データとキャッシュのリセット
                    realmService.deleteFixedLocations()
                    ImageCacheManager.clearCache()
                    
                    // Firebaseデータの保存と画像プリフェッチ
                    realmService.saveFixedLocations(fixedLocations)
                    let imageUrls = fixedLocations.flatMap(\.imageUrlsArr).compactMap(URL.init)
                    ImageCacheManager.prefetch(from: imageUrls)
                })
                : Observable.just(realmData)
                return locationData
            }
            .flatMap { fixedLocations in
                // 各ロケーションの状況、訪問情報、ユーザープロフィールを取得
                Observable.zip(
                    mainService.fetchLocations(), // 各ロケーションの状態を取得
                    mainService.fetchVisitedLocations(), // 各ロケーションの訪問情報を取得
                    mainService.fetchUserProfile() // ユーザープロフィール取得
                        .map { userProfile in
                            // プロフィール画像をプリフェッチ 空の場合はデフォルト画像を適用
                            if !userProfile.profileImageUrl.isEmpty {
                                ImageCacheManager.prefetch(from: [URL(string: userProfile.profileImageUrl)!])
                            }
                            return userProfile
                        }
                )
                .map { (dynamicLocations: [DynamicLocation], visitedLocations: [VisitedLocation], userProfile: User) in
                    // userProfileをコピー
                    var mutableUserProfile = userProfile
                    
                    // LocationsInfoとuserProfileのタプル作成
                    var locationsInfo = LocationsInfo(
                        fixedLocations: fixedLocations,
                        dynamicLocations: dynamicLocations,
                        visitedLocations: visitedLocations
                    )
                    
                    let ticketsInfo = MapViewModel.createTicketsInfo(userProfile: userProfile, locationsInfo: locationsInfo)
                    let locationsStatus = MapViewModel.createLocationStatus(currentLocationId: userProfile.currentLocationId, ticketsInfo: ticketsInfo, locationsInfo: locationsInfo)
                    let progressSum = MapViewModel.createStudyProgressSummary(fixedLocations: fixedLocations, visitedLocations: visitedLocations, locationsStatus: locationsStatus)
                    // 上書き
                    locationsInfo = LocationsInfo(
                        fixedLocations: fixedLocations,
                        dynamicLocations: dynamicLocations,
                        visitedLocations: visitedLocations,
                        ticketsInfo: ticketsInfo, // 各ロケーションごとのチケット上のUIに表示する情報（配列）を追加
                        locationStatus: locationsStatus // 各ロケーションごとの状態（配列）追加
                    )
                    // progressSumに値をセット
                    mutableUserProfile.progressSum = progressSum
                    
                    return (locationsInfo, mutableUserProfile)
                }
                .trackActivity(indicator)
            }
            .materialize()
            .share(replay: 1)
        
        // マップに配置するロケーション関連の情報を流す
        self.locationsAndUserInfo = fetchLocationsInfoResult
            .compactMap { $0.event.element }
            .asDriver(onErrorJustReturn: (LocationsInfo(), User()))
        
        // マップに配置するロケーション関連の情報取得エラーを流す
        let fetchLocationsInfoError = fetchLocationsInfoResult
            .compactMap { $0.event.error as? MyAppError }
        
        // 発生したエラーを一つに集約
        self.myAppError = Observable
            .merge(fetchLocationsInfoError)
            .asDriver(onErrorJustReturn: .unknown)
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
                currentCoin: currentCoin
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
            // ロケーション状態構造体を生成
            let locationStatus = LocationStatus(
                locationId: fixedLocationId,
                userCount: userCount,
                isSufficientCoin: isSufficientCoin,
                isMyCurrentLocation: isMyCurrentLocation,
                isCompleted: isCompleted,
                isOngoing: isOngoing
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
