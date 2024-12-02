//
//  OnFlightViewModel.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/01.
//

import Foundation
import Firebase
import RxSwift
import RxCocoa

class OnFlightViewModel {
    
    // MARK: - Output
    let userProfiles: Driver<[User]>
    let latestLoadedDocDate: Driver<Timestamp?>
    let oldestDocument: Driver<QueryDocumentSnapshot?>
    let isLoading: Driver<Bool>
    let myAppError: Driver<MyAppError>
    
    private let limit: Int = 16 // 初回読み込み件数
    
    init(mainService: MainServiceProtocol, locationInfo: LocationInfo) {
        
        // 一度全キャッシュクリア
        ImageCacheManager.clearCache()
        // 必要な画像のみプリフェッチ
        let imageUrls = locationInfo.fixedLocation.imageUrls.compactMap { URL(string: $0) }
        ImageCacheManager.prefetch(from: imageUrls)
        
        let locationId = locationInfo.fixedLocation.locationId // ロケーションID
        let remainingCoin = locationInfo.ticketInfo.remainingCoin // 旅費支払い後の残高
        
        let indicator = ActivityIndicator()
        self.isLoading = indicator.asDriver()
        
        let updateAndAddEventResult = Observable.combineLatest(
            mainService.updateCurrentCoinAndLocationId(locationId: locationId, currentCoin: remainingCoin),
            mainService.addUserIdToLocation(locationId: locationId)
        )
        
        let fetchUsersInfoResult = mainService.fetchUserIdsInLocation(locationId: locationId, limit: limit)
            .flatMap { userIds, latestLoadedDocDate, oldestDocument in
                mainService.fetchUserProfiles(userIds: userIds, isInitialFetch: true)
                    .map { userProfiles in
                        // ユーザープロフィール画像をプリフェッチ
                        OnFlightViewModel.prefetch(imageUrlsString: userProfiles.map { $0.profileImageUrl })
                        return (userProfiles: userProfiles, latestLoadedDocDate: latestLoadedDocDate, oldestDocument: oldestDocument)
                    }
            }
        
        let result = updateAndAddEventResult
            .flatMap { _, _ in fetchUsersInfoResult }
            .trackActivity(indicator)
            .materialize()
            .share(replay: 1)
        
        self.userProfiles = result
            .compactMap { $0.event.element?.userProfiles }
            .asDriver(onErrorJustReturn: [])
        
        self.latestLoadedDocDate = result
            .compactMap { $0.event.element?.latestLoadedDocDate }
            .asDriver(onErrorJustReturn: nil)
        
        self.oldestDocument = result
            .compactMap { $0.event.element?.oldestDocument }
            .asDriver(onErrorJustReturn: nil)
      
        self.myAppError = result
            .compactMap { $0.event.error as? MyAppError }
            .asDriver(onErrorJustReturn: .unknown)
    }
}

extension OnFlightViewModel {
    private static func prefetch(imageUrlsString: [String]) {
        let imageUrls = imageUrlsString.compactMap { URL(string: $0) }
        ImageCacheManager.prefetch(from: imageUrls)
    }
}
