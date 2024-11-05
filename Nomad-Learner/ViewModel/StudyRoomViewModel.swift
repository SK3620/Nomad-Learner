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
    
    // 画面レイアウト切り替え
    enum RoomLayout {
        case displayAll // 全て表示
        case hideProfile // プロフィール欄非表示
        case hideChat // チャット欄非表示
        case hideAll // 全て非表示
    }
    
    // UIメニューアクション
    enum MenuAction {
        case breakTime // 休憩
        case restart // 勉強再開
        case community // コミュニティ
        case exitRoom // 退出
    }
    
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
    // 経過時間（秒数）から時間/分単位を算出
    private var elapsedStudyTime: (hours: Int, mins: Int) {
        let hours = Int(elapsedTime / 3600) // 秒数から時間単位を算出
        let minutes = Int(elapsedTime % 3600) / 60 // 秒数から分単位を算出
        return (hours: hours, mins: minutes)
    }
    // 元々の合計勉強時間を取得
    private var originalStudyTime: (hours: Int, mins: Int) {
        return (
            hours: locationInfo.ticketInfo.totalStudyHours,
            mins: locationInfo.ticketInfo.totalStudyMins
        )
    }
    
    private let indicator: ActivityIndicator = ActivityIndicator()
    private let disposeBag = DisposeBag()
    
    // タイマー
    private let timerTextRelay = BehaviorRelay<String>(value: "00:00:00")
    // プロフィール
    private let userProfilesRelay = BehaviorRelay<[User]>(value: [])
    // チャット欄のメッセージ
    private let messageRelay = BehaviorRelay<[Message]>(value: [])
    // 画面レイアウト
    private let roomLayoutRelay = BehaviorRelay<RoomLayout>(value: .displayAll)
    // UIメニューアクション
    private let menuActionRelay = BehaviorRelay<MenuAction?>(value: .none)
    // 押下されたIndexPath
    private let tappedIndexRelay = BehaviorRelay<IndexPath>(value: IndexPath(row: 0, section: 0))
    
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
    var messages: Driver<[Message]> {
        return messageRelay.asDriver()
    }
    var roomLayout: Driver<RoomLayout> {
        return roomLayoutRelay.asDriver()
    }
    var menuAction: Driver<MenuAction?> {
        return menuActionRelay.asDriver()
    }
    var tappedIndex: Driver<IndexPath> {
        return tappedIndexRelay.asDriver()
    }
    let isLoading: Driver<Bool>
    var myAppError: Driver<MyAppError> = Driver.just(MyAppError.unknown).skip(1) // 初期化&初期値を意図的にskip(1)させる
    
    // MARK: - Dependency
    private var mainService: MainServiceProtocol
    private var locationInfo: LocationInfo
    private lazy var locationId: String = { self.locationInfo.fixedLocation.locationId }()
    private var latestLoadedDocDate: Timestamp?
    private var oldestDocument: QueryDocumentSnapshot?
    
    init(
        mainService: MainServiceProtocol,
        locationInfo: LocationInfo,
        initialLoadedUserProfiles: [User],
        latestLoadedDocDate: Timestamp?,
        oldestDocument: QueryDocumentSnapshot?
    ) {
        self.mainService = mainService
        self.locationInfo = locationInfo
        self.latestLoadedDocDate = latestLoadedDocDate
        self.oldestDocument = oldestDocument
        
        // 初回で取得したユーザープロフィール情報を流す
        self.userProfilesRelay.accept(initialLoadedUserProfiles)
        
        // ローディングインジケーター
        self.isLoading = indicator.asDriver()
        
        // 背景画像切り替え
        self.backgroundImageUrl = Observable<Int>.interval(.seconds(10), scheduler: MainScheduler.instance)
            .map { index in locationInfo.fixedLocation.imageUrlsArr[index % locationInfo.fixedLocation.imageUrlsArr.count] }
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
        let listenForNewUsersParticipationResult = mainService.listenForNewUsersParticipation(locationId: locationId, latestLoadedDocDate: latestLoadedDocDate!)
            .flatMap { tuple -> Observable<([User], Timestamp?)> in
                let (userIds, latestLoadedDocDate) = tuple
                return self.mainService.fetchUserProfiles(userIds: userIds)
                    .map { (userProfiles: $0, latestLoadedDocDate: latestLoadedDocDate) }
            }
            .materialize()
            .share(replay: 1)
        
        listenForNewUsersParticipationResult
            .compactMap { $0.event.element }
            .subscribe(onNext: { [weak self] (userProfiles, latestLoadedDocDate) in
                guard let self = self else { return }
                self.userProfilesRelay.accept(self.userProfilesRelay.value + userProfiles)
                self.latestLoadedDocDate = latestLoadedDocDate
            })
            .disposed(by: disposeBag)
        
        self.myAppError = listenForNewUsersParticipationResult
            .compactMap { $0.event.error as? MyAppError }
            .asDriver(onErrorJustReturn: .unknown)
        
        
        messageRelay.accept(Message.messages)
    }
}

extension StudyRoomViewModel {
    
    // 押下されたcellのIndexPath情報を保持させる
    func tappedProfile(at indexPath: IndexPath) {
        tappedIndexRelay.accept(indexPath)
    }
    
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
                return self.mainService.fetchUserProfiles(userIds: userIds)
                    .map { (userProfiles: $0, oldestDocument: oldestDocument) }
            }
            .trackActivity(indicator)
            .materialize()
            .share(replay: 1)
        
        fetchMoreUserProfiles
            .compactMap { $0.event.element }
            .subscribe(onNext: { [weak self] (userProfiles, oldestDocument) in
                guard let self = self else { return }
                self.userProfilesRelay.accept(self.userProfilesRelay.value + userProfiles)
                self.oldestDocument = oldestDocument
            })
            .disposed(by: disposeBag)
        
        self.myAppError = fetchMoreUserProfiles
            .compactMap { $0.event.error as? MyAppError }
            .asDriver(onErrorJustReturn: .unknown)
    }
    
    // 勉強時間データ保存（退出時）
    func saveStudyProgress(countedStudyTime: Int, completion: () -> Void) {
        let updatedData = StudyProgressAndReward(
            totalStudyHours: originalStudyTime.hours + elapsedStudyTime.hours,
            totalStudyMins: originalStudyTime.mins + elapsedStudyTime.mins,
            missionStudyTime: locationInfo.ticketInfo.missionStudyTime,
            rewardCoin: locationInfo.ticketInfo.rewardCoin
        )
        
        let saveStudyProgressResult = mainService.removeUserIdFromLocation(locationId: locationId)
            .flatMap { [weak self] (_) -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.mainService.saveStudyProgressAndRewards(updatedData: updatedData)
            }
            .materialize()
            .share(replay: 1)
        
        saveStudyProgressResult
            .compactMap { $0.event.element }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, let userId = FBAuth.currentUserId else { return }
                if let index = self.userProfilesRelay.value.firstIndex(where: { $0.userId == userId}) {
                    var updatedProfiles = userProfilesRelay.value
                    updatedProfiles.remove(at: index)
                    userProfilesRelay.accept(updatedProfiles)
                }
            })
            .disposed(by: disposeBag)
        
        self.myAppError = saveStudyProgressResult
            .compactMap { $0.event.error as? MyAppError }
            .asDriver(onErrorJustReturn: .unknown)
    }
}

struct StudyProgressAndReward {
    let totalStudyHours: Int
    let totalStudyMins: Int
    let missionStudyTime: Int
    let rewardCoin: Int
    
    init(totalStudyHours: Int, totalStudyMins: Int, missionStudyTime: Int, rewardCoin: Int) {
        self.totalStudyHours = totalStudyHours
        self.totalStudyMins = totalStudyMins
        self.missionStudyTime = missionStudyTime
        self.rewardCoin = rewardCoin
    }
    
    var toDictionary: [String: Any] {
        return [
            "totalStudyHours": totalStudyHours,
            "totalStudyMins": totalStudyMins,
            "missionStudyTime": missionStudyTime,
            "rewardCoin": rewardCoin
        ]
    }
}
