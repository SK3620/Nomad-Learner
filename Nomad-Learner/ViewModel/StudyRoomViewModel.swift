//
//  StudyRoomViewModel.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/13.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

class StudyRoomViewModel {
    
    private var lastVisibleDocument: DocumentSnapshot? // 最後に取得したドキュメント
    private let limit: Int = 16 // 一度に取得するユーザーの数
    
    // 勉強経過時間を秒数で保持
    private var elapsedTime = 0
    // タイマー再開/停止
    private var isPaused = false // 初期値は開始
    // UIに表示するフォーマット（00:00:00）
    private var formattedElapsedTime: String {
        String(format: "%02d:%02d:%02d", elapsedTime / 3600, (elapsedTime % 3600) / 60, elapsedTime % 60)
    }
    // 経過時間の時間/分単位を算出
    private var elapsedStudyTime: (hours: Int, mins: Int) {
        (hours: elapsedTime / 3600, mins: (elapsedTime % 3600) / 60)
    }
    
    // 元々の勉強時間
    private var originalStudyTime: (hours: Int, mins: Int) {
        (hours: locationInfo.ticketInfo.totalStudyHours, mins: locationInfo.ticketInfo.totalStudyMins)
    }
    
    // 合計勉強時間（時間/分単位）
    private var totalStudyTime: (hours: Int, mins: Int) {
        let totalHours = originalStudyTime.hours + elapsedStudyTime.hours
        let totalMins = originalStudyTime.mins + elapsedStudyTime.mins
        return (hours: totalHours + totalMins / 60, mins: totalMins % 60)
    }
    
    // 現在の勉強時間（時間/分単位）
    private var currentStudyTime: (hours: Int, mins: Int) {
        let totalMinutes1 = totalStudyTime.hours * 60 + totalStudyTime.mins // 分単位に換算
        let totalMinutes2 = originalStudyTime.hours * 60 + originalStudyTime.mins // 分単位に換算
        let differenceInMinutes = totalMinutes1 - totalMinutes2 // 分単位で差分を算出
        return (hours: differenceInMinutes / 60, mins: differenceInMinutes % 60)
    }
    
    // 加算される報酬コイン
    private var addedRewardCoin: Int = 0
    // 更新するデータ
    private var visitedLocationToUpdate: VisitedLocation {
        createVisitedLocation()
    }
    
    private let indicator: ActivityIndicator = ActivityIndicator()
    private let disposeBag = DisposeBag()
    
    // タイマー
    private let timerTextRelay = BehaviorRelay<String>(value: "00:00:00")
    // プロフィール
    private let userProfilesRelay = BehaviorRelay<[User]>(value: [])
    // チャット欄のメッセージ
    private let messageRelay = BehaviorRelay<[UserProfileChange]>(value: [])
    // 画面レイアウト
    private let roomLayoutRelay = BehaviorRelay<RoomLayout>(value: .displayAll)
    // UIメニューアクション
    private let menuActionRelay = BehaviorRelay<MenuAction?>(value: .none)
    // エラー
    private let myAppErrorRelay = BehaviorRelay<MyAppError?>(value: nil)
    
    // MARK: - Output 外部公開
    // タイマー
    var timerText: Driver<String> {
        return timerTextRelay.asDriver()
    }
    // 背景画像
    var backgroundImageUrl: Driver<String>
    
    var userProfiles: Driver<[User]> {
        return userProfilesRelay.asDriver()
    }
    var messages: Driver<[UserProfileChange]> {
        return messageRelay.asDriver()
    }
    var roomLayout: Driver<RoomLayout> {
        return roomLayoutRelay.asDriver()
    }
    var menuAction: Driver<MenuAction?> {
        return menuActionRelay.asDriver()
    }
    var myAppError: Driver<MyAppError> {
        return myAppErrorRelay.compactMap { $0 }.asDriver(onErrorJustReturn: .unknown)
    }
    let isLoading: Driver<Bool>
    
    // MARK: - Dependency
    private let mainService: MainServiceProtocol
    private let realmService: RealmServiceProtocol
    private var locationInfo: LocationInfo
    private lazy var locationId: String = { self.locationInfo.fixedLocation.locationId }()
    private var oldestDocument: QueryDocumentSnapshot?
    
    init(
        mainService: MainServiceProtocol,
        realmService: RealmServiceProtocol,
        locationInfo: LocationInfo,
        initialLoadedUserProfiles: [User],
        oldestDocument: QueryDocumentSnapshot?
    ) {
        self.mainService = mainService
        self.realmService = realmService
        self.locationInfo = locationInfo
        self.oldestDocument = oldestDocument
        
        self.userProfilesRelay.accept(initialLoadedUserProfiles.sorted)
        
        // 自分のユーザープロフィールを取得しチャット一覧に"勉強開始"を表示させる
        if let myUserProfile = initialLoadedUserProfiles.first(where: { $0.userId == FBAuth.currentUserId }) {
            self.messageRelay.accept([.added(myUserProfile)])
        }
        
        // ローディングインジケーター
        self.isLoading = indicator.asDriver()
        
        // 背景画像切り替え
        self.backgroundImageUrl = Observable<Int>.interval(.seconds(10), scheduler: MainScheduler.instance)
            .map { index in locationInfo.fixedLocation.imageUrls[index % locationInfo.fixedLocation.imageUrls.count] }
            .asDriver(onErrorJustReturn: "Globe")
        
        // 1秒ごとに勉強時間をカウント
        Driver<Int>.interval(.seconds(1))
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                // タイマーが再開中である場合のみ時間をカウント
                if !self.isPaused {
                    self.elapsedTime += 1
                    self.timerTextRelay.accept(self.formattedElapsedTime)
                }
            })
            .disposed(by: disposeBag)
        
        // 参加してきた新規ユーザーをリッスン
        let listenForNewUsersParticipationResult = mainService.listenForNewUsersParticipation(locationId: locationId)
            .flatMap { userIds in self.mainService.fetchUserProfiles(userIds: userIds, isInitialFetch: false) }
            .materialize()
        
        listenForNewUsersParticipationResult
            .compactMap { $0.event.element }
            .subscribe(onNext: { [weak self] userProfiles in
                guard let self = self else { return }
                // 新規ユーザーのプロフィール画像をプリフェッチ
                StudyRoomViewModel.prefetch(imageUrlsString: userProfiles.map { $0.profileImageUrl })
                let addedUserProfiles: [UserProfileChange] = userProfiles.map { .added($0) }
                self.messageRelay.accept(self.messageRelay.value + addedUserProfiles)
                self.userProfilesRelay.accept((self.userProfilesRelay.value + userProfiles).sorted)
            })
            .disposed(by: disposeBag)
        
        // 退出したユーザーをリッスン
        let listenForUsersExitResult = mainService.listenForUsersExit(locationId: locationId)
            .materialize()
        
        listenForUsersExitResult
            .compactMap { $0.event.element }
            .subscribe(onNext: { [weak self] userIds in
                guard let self = self else { return }
                // 退出したユーザーIDに基づいて更新処理
                var profilesToRemove = self.userProfilesRelay.value.filter { userIds.contains($0.userId) }
                // 自分のユーザープロフィールを除外
                profilesToRemove.removeAll(where: { $0.userId == FBAuth.currentUserId })
                // 退出ユーザーのプロフィール画像をプリフェッチ
                StudyRoomViewModel.prefetch(imageUrlsString: profilesToRemove.map { $0.profileImageUrl })
                // ユーザーの削除メッセージを追加
                let updatedMessages = self.messageRelay.value + profilesToRemove.map { .removed($0) }
                self.messageRelay.accept(updatedMessages)
                // ユーザープロフィールの更新
                let updatedProfiles = self.userProfilesRelay.value.filter { !userIds.contains($0.userId) }
                self.userProfilesRelay.accept(updatedProfiles.sorted)
            })
            .disposed(by: disposeBag)
    }
}

extension StudyRoomViewModel {
    // レイアウトの切り替え
    func switchRoomLayout() {
        let layout = roomLayoutRelay.value
        switch layout {
        case .displayAll:
            roomLayoutRelay.accept(.hideProfile)
        case .hideProfile:
            roomLayoutRelay.accept(.hideChat)
        case .hideChat:
            roomLayoutRelay.accept(.hideAll)
        case .hideAll:
            roomLayoutRelay.accept(.displayAll)
        }
    }
    
    // メニューで選択されたアクション（休憩、退出、コミュニティ）を発行
    func handleMenuAction(action: MenuAction) {
        switch action {
        case .breakTime:
            menuActionRelay.accept(.breakTime)
            self.isPaused = true
        case .restart:
            menuActionRelay.accept(.restart)
            self.isPaused = false
        case .confirmTicket:
            menuActionRelay.accept(.confirmTicket)
        case .community:
            menuActionRelay.accept(.community)
        case .exitRoom:
            menuActionRelay.accept(.exitRoom)
        }
    }
    
    // 追加データ取得（ページネーション）
    func fetchMoreUserProfiles() {
        let fetchMoreUserProfiles = mainService.fetchMoreUserIdsInLocation(locationId: locationId, limit: limit, oldestDocument: oldestDocument)
            .flatMap { [weak self] tuple -> Observable<([User], QueryDocumentSnapshot?)> in
                guard let self = self else { return .just(([], nil)) }
                let (userIds, oldestDocument) = tuple
                return self.mainService.fetchUserProfiles(userIds: userIds, isInitialFetch: false)
                    .map { (userProfiles: $0, oldestDocument: oldestDocument) }
            }
            .trackActivity(indicator)
            .materialize()
        
        fetchMoreUserProfiles
            .compactMap { $0.event.element }
            .subscribe(onNext: { [weak self] (userProfiles, oldestDocument) in
                guard let self = self else { return }
                self.userProfilesRelay.accept((self.userProfilesRelay.value + userProfiles).sorted)
                self.oldestDocument = oldestDocument
            })
            .disposed(by: disposeBag)
    }
    
    // 勉強記録等保存（退出時）
    func saveStudyProgress(completion: @escaping () -> Void = {}, shouldSaveLocallyOnKill: Bool = false) {
        // アプリをキルした場合でもローカルに勉強記録等を保存しておく
        if shouldSaveLocallyOnKill, let pendingUpdateData = PendingUpdateData.create(visitedLocation: visitedLocationToUpdate, addedRewardCoin: addedRewardCoin) {
            realmService.savePendingUpdateData(pendingUpdateData: pendingUpdateData)
            return
        }
        
        let combinedObservableResult = Observable.zip(
            mainService.removeUserIdFromLocation(locationId: locationId),
            mainService.saveStudyProgressAndRewards(locationId: locationId, updatedData: visitedLocationToUpdate),
            mainService.updateCurrentCoin(addedRewardCoin: addedRewardCoin)
        )
            .catch { [weak self] error in
                self?.myAppErrorRelay.accept(error as? MyAppError)
                return .empty()
            }
            .materialize()
            .share(replay: 1)
        
        combinedObservableResult
            .compactMap { $0.event.element }
            .subscribe(onNext: { [weak self] _ in
                self?.mainService.removeListeners() // 監視解除
                self?.realmService.deletePendingUpdateData() // Realmの既存データを削除
                completion() // MapVC（マップ画面）に戻る
            })
            .disposed(by: disposeBag)
    }
}

extension StudyRoomViewModel {
    private func createVisitedLocation() -> VisitedLocation {
        // completionFlagの状態を取得 (0:未達成, 1:初達成, 2以上:既達成)
        let currentCompletionFlag = locationInfo.visitedLocation?.completionFlag ?? 0

        // 必要な勉強時間を達成しているかどうか
        let hasAchievedRequiredStudyTime = totalStudyTime.hours >= locationInfo.ticketInfo.requiredStudyHours
        // 初めての達成であるかどうか
        let isFirstCompletion = hasAchievedRequiredStudyTime && currentCompletionFlag == 0
        // 達成しているかどうか
        let isAlreadyCompleted = currentCompletionFlag >= 1
        // ボーナスコインの計算
        let bonusCoin = isFirstCompletion || isAlreadyCompleted ? currentStudyTime.hours * MyAppSettings.bonusCoinMultiplier : 0
        // 新しいcompletionFlagの計算
        let updatedCompletionFlag = isFirstCompletion || isAlreadyCompleted ? currentCompletionFlag + 1 : 0
        // 加算される報酬コインの合計
        addedRewardCoin += isFirstCompletion ? locationInfo.ticketInfo.rewardCoin : 0
        addedRewardCoin += bonusCoin

        return VisitedLocation(
            locationId: locationId,
            totalStudyHours: totalStudyTime.hours,
            totalStudyMins: totalStudyTime.mins,
            fixedRequiredStudyHours: locationInfo.ticketInfo.requiredStudyHours,
            fixedRewardCoin: locationInfo.ticketInfo.rewardCoin,
            completionFlag: updatedCompletionFlag,
            bonusCoin: bonusCoin
        )
    }
}

extension StudyRoomViewModel {
    // ユーザープロフィール画像のプリフェッチ
    private static func prefetch(imageUrlsString: [String]) {
        let imageUrls = imageUrlsString.compactMap { URL(string: $0) }
        ImageCacheManager.prefetch(from: imageUrls)
    }
}
