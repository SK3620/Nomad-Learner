//
//  MainServiceProtocol.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/21.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

protocol MainServiceProtocol {
    // Firebaseからロケーションデータ取得
    func fetchFixedLocations() -> Observable<[FixedLocation]>
    // ロケーション情報の変更を監視
    // func monitorFixedLocationsChanges() -> Observable<[FixedLocation]>
    // プロフィール画像保存
    func saveProfileImage(image: UIImage) -> Observable<String>
    // ユーザープロフィール保存
    func saveUserProfile(user: User, shouldUpdate: Bool) -> Observable<Void>
    // ユーザープロフィール取得
    func fetchUserProfile() -> Observable<User>
    // 訪問したロケーション情報を取得
    func fetchVisitedLocations() -> Observable<[VisitedLocation]>
    // マップ上の各ロケーションの状態の取得
    func fetchLocations() -> Observable<[DynamicLocation]>
    // ユーザープロフィールの現在のロケーションIDと現在の所持金を更新
    func updateCurrentCoinAndLocationId(locationId: String, currentCoin: Int) ->  Observable<Void>
    // 参加中のロケーションにuuidを追加
    func addUserIdToLocation(locationId: String) -> Observable<Void>
    // ロケーションに参加中のユーザーのuuidを取得
    func fetchUserIdsInLocation(locationId: String, limit: Int) -> Observable<(userIds: [String], oldestDocument: QueryDocumentSnapshot?)>
    // ロケーションに参加中のユーザーのプロフィール情報を取得
    func fetchUserProfiles(userIds: [String], isInitialFetch: Bool) -> Observable<[User]>
    // ページネーションで追加データ取得
    func fetchMoreUserIdsInLocation(locationId: String, limit: Int, oldestDocument: QueryDocumentSnapshot?) -> Observable<(userIds: [String], oldestDocument: QueryDocumentSnapshot?)>
    // ロケーションに参加する他ユーザーをリアルタイムリッスン
    func listenForNewUsersParticipation(locationId: String) -> Observable<[String]>
    // 退出したユーザーをリッスン
    func listenForUsersExit(locationId: String) -> Observable<[String]>
    // 勉強部屋から退出
    func removeUserIdFromLocation(locationId: String) -> Observable<Void>
    // 勉強部屋からの退出時、合計勉強時間、ミッション勉強時間、報酬コインを保存
    func saveStudyProgressAndRewards(locationId: String, updatedData: VisitedLocation) -> Observable<Void>
    // 所持金に報酬コインを加算
    func updateCurrentCoin(addedRewardCoin: Int) -> Observable<Void>
    
    /*
    // 監視解除
    func removeObserver()
     */
    // リスナー解除
    func removeListeners()
}

final class MainService: MainServiceProtocol {
    
    public static let shared = MainService()
    
    private let firebaseConfig = FirebaseConfig.shared
    
    private init(){}
    
    private var observerForFixedLocationsChanges: UInt?
    private var listenerForUsersExit: ListenerRegistration?
    private var listenerForNewUsersParticipation: ListenerRegistration?
    
    /*
    func removeObserver() {
        guard let observer = observerForFixedLocationsChanges else { return }
        firebaseConfig.fixedLocationsReference().removeObserver(withHandle: observer)
    }
     */
    
    func removeListeners() {
        listenerForUsersExit?.remove()
        listenerForNewUsersParticipation?.remove()
        listenerForUsersExit = nil
        listenerForNewUsersParticipation = nil
    }
    
    // マップのマーカーに設定するロケーション情報取得
    func fetchFixedLocations() -> Observable<[FixedLocation]> {
        return Observable.create { observer in
            let ref = self.firebaseConfig.fixedLocationsReference()
            ref.getData { error, snapshot in
                if let error = error {
                    observer.onError(MyAppError.fetchLocationInfoFailed(error))
                }
                else if let children = snapshot?.children {
                    var fixedLocations: [FixedLocation] = []
                    for child in children {
                        if let childSnapshot = child as? DataSnapshot,
                           let locationData = childSnapshot.value as? [String: Any],
                           let fixedLocation = FixedLocationParser.parse(childSnapshot.key, locationData)
                        {
                            fixedLocations.append(fixedLocation)
                        } else {
                            observer.onError(MyAppError.fetchLocationInfoFailed(nil))
                        }
                    }
                    observer.onNext(fixedLocations)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    /*
    // ロケーション情報の変更を監視
    func monitorFixedLocationsChanges() -> Observable<[FixedLocation]> {
        return Observable.create { observer in
            let ref = self.firebaseConfig.fixedLocationsReference()
            self.observerForFixedLocationsChanges = ref.observe(.value) { snapshot in
                var locations = [FixedLocation]()
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let locationData = childSnapshot.value as? [String: Any],
                       let location = FixedLocationParser.parse(childSnapshot.key, locationData) {
                        locations.append(location)
                    }
                }
                observer.onNext(locations)
            }
            return Disposables.create()
        }
    }
     */
    
    // プロフィール画像保存
    func saveProfileImage(image: UIImage) -> Observable<String> {
        return Observable.create { observer in
            guard let userId = FBAuth.currentUserId else {
                observer.onError(MyAppError.userNotFound)
                return Disposables.create()
            }
            
            // 画像をJPEG形式に変換する
            let imageData = image.jpegData(compressionQuality: 0.75)
            // 画像と投稿データの保存場所を定義する
            let profileImageRef = self.firebaseConfig.profileImagesReference(with: userId)
            // Storageに画像をアップロードする
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            profileImageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
                if let error = error {
                    observer.onError(MyAppError.saveUserProfileImageFailed(error))
                }
                else if let _ = metadata {
                    profileImageRef.downloadURL { url, error in
                        if let error = error {
                            observer.onError(MyAppError.handleAll(error))
                        }
                        if let downloadUrl = url {
                            observer.onNext(downloadUrl.absoluteString)
                        } else {
                            observer.onError(MyAppError.handleAll(nil))
                        }
                    }
                } else {
                    observer.onError(MyAppError.handleAll(nil))
                }
            }
            return Disposables.create()
        }
    }
    
    // ユーザープロフィール保存
    func saveUserProfile(user: User, shouldUpdate: Bool = false) -> Observable<Void> {
        return Observable.create { observer in
            guard let userId = FBAuth.currentUserId else {
                observer.onError(MyAppError.userNotFound)
                return Disposables.create()
            }
            
            var userData: [String: Any] = [:]
            if shouldUpdate {
                userData = user.toDictionaryForUpdate
            } else {
                userData = user.toDictionary
            }
            // Firestoreにユーザー情報を保存
            self.firebaseConfig.usersCollectionReference().document(userId)
                .setData(userData, merge: true) { error in
                if let error = error {
                    observer.onError(MyAppError.saveUserProfileFailed(error))
                } else {
                    observer.onNext(())
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    // ユーザープロフィール取得
    func fetchUserProfile() -> Observable<User> {
        return Observable.create { observer in
            guard let userId = FBAuth.currentUserId else {
                observer.onError(MyAppError.userNotFound)
                return Disposables.create()
            }
            // Firestoreからユーザーデータを取得
            self.firebaseConfig.usersCollectionReference().document(userId).getDocument { document, error in
                if let error = error {
                    observer.onError(MyAppError.fetchUserProfileFailed(error))
                } else if let document = document, document.exists, let userData = document.data() {
                    // データをUserモデルに変換
                    if let fetchedUser = UserParser.parse(document.documentID, userData) {
                        observer.onNext(fetchedUser)
                        observer.onCompleted()
                    } else {
                        observer.onError(MyAppError.fetchUserProfileFailed(nil))
                    }
                } else {
                    observer.onError(MyAppError.fetchUserProfileFailed(nil))
                }
            }
            return Disposables.create()
        }
    }
    
    // ユーザーが訪れたロケーションを取得
    func fetchVisitedLocations() -> Observable<[VisitedLocation]> {
        return Observable.create { observer in
            guard let userId = FBAuth.currentUserId else {
                observer.onError(MyAppError.userNotFound)
                return Disposables.create()
            }
            
            self.firebaseConfig.visitedCollectionReference(with: userId).getDocuments { snapshots, error in
                if let error = error {
                    observer.onError(MyAppError.fetchLocationInfoFailed(error))
                } else {
                    let visitedLocations = snapshots?.documents.compactMap { VisitedLocationParser.parse($0.documentID, $0.data())} ?? []
                    
                    observer.onNext(visitedLocations)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    // マップ上の各ロケーションの状態の取得
    func fetchLocations() -> Observable<[DynamicLocation]> {
        Observable.create { observer in
            self.firebaseConfig.locationsCollectionReference().getDocuments { snapshots, error in
                if let error = error {
                    observer.onError(MyAppError.fetchLocationInfoFailed(error))
                } else  {
                    let fixedLocations = snapshots?.documents.compactMap {
                        LocationParser.parse($0.documentID, $0.data())
                    } ?? []
                    
                    observer.onNext(fixedLocations)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    // ユーザープロフィールの現在のロケーションIDと現在の所持金を更新
    func updateCurrentCoinAndLocationId(locationId: String, currentCoin: Int) -> Observable<Void> {
        Observable.create { observer in
            guard let userId = FBAuth.currentUserId else {
                observer.onError(MyAppError.userNotFound)
                return Disposables.create()
            }
//            guard !self.isTrialUse else {
//                observer.onError(MyAppError.featureAccessDeniedInTrial)
//                return Disposables.create()
//            }
            
            let updatedData = [
                "currentCoin": currentCoin,
                "currentLocationId": locationId
            ]
            self.firebaseConfig.usersCollectionReference().document(userId)
                .updateData(updatedData) { error in
                    if let error = error {
                        observer.onError(MyAppError.updateCurrentCoinAndLocationIdFailed(error))
                    } else {
                        observer.onNext(())
                        observer.onCompleted()
                    }
                }
            return Disposables.create()
        }
    }
    
    // 参加中のロケーションにuuidを追加＆参加ユーザー数を+1インクリメント
    func addUserIdToLocation(locationId: String) -> Observable<Void> {
        Observable.create { observer in
            guard let userId = FBAuth.currentUserId else {
                observer.onError(MyAppError.userNotFound)
                return Disposables.create()
            }
            
            // 初期データとして userCount のフィールドを 1 インクリメント
            let locationRef = self.firebaseConfig.locationsCollectionReference().document(locationId)
            locationRef.setData([
                "userCount": FieldValue.increment(Int64(1))  // userCountを+1インクリメント
            ], merge: true) { error in
                if let error = error {
                    observer.onError(MyAppError.addUserIdToLocationFailed(error))
                } else {
                    // users サブコレクションにユーザーIDを追加
                    let userRef = self.firebaseConfig.usersInLocationsReference(with: locationId).document(userId)
                    userRef.setData([
                        "createdAt": FieldValue.serverTimestamp()  // 作成日時を追加
                    ], merge: true) { error in
                        if let error = error {
                            observer.onError(MyAppError.incrementUserCountFailed(error))
                        } else {
                            observer.onNext(())
                            observer.onCompleted()
                        }
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    // ロケーションに参加中のユーザーのuuidを取得（初回読み込み）
    func fetchUserIdsInLocation(locationId: String, limit: Int) -> Observable<(userIds: [String], oldestDocument: QueryDocumentSnapshot?)> {
        Observable.create { observer in
            let query = self.firebaseConfig.usersInLocationsReference(with: locationId)
                .order(by: "createdAt", descending: true)
                .limit(to: limit) // 最新の指定件数を取得
            
            query.getDocuments { snapshots, error in
                if let error = error {
                    observer.onError(MyAppError.fetchUserIdsInLocationFailed(error))
                } else if let documents = snapshots?.documents, !documents.isEmpty {
                    // ユーザーのuuidを取得
                    let userIds: [String] = documents.compactMap { $0.documentID }
                    let oldestDocument = documents.last // 一番古いドキュメントを取得
                    observer.onNext((userIds: userIds, oldestDocument: oldestDocument))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    // ロケーションに参加中のユーザーのプロフィール情報を取得
    func fetchUserProfiles(userIds: [String], isInitialFetch: Bool = false) -> Observable<[User]> {
        Observable.create { observer in
            guard !userIds.isEmpty else {
                isInitialFetch
                ? observer.onError(MyAppError.userNotFound)
                : observer.onNext([])
                return Disposables.create()
            }
            
            let query = self.firebaseConfig.usersCollectionReference()
                .whereField(FieldPath.documentID(), in: userIds)
            query.getDocuments { snapshots, error in
                if let error = error {
                    isInitialFetch
                    ? observer.onError(MyAppError.fetchUserProfilesFailed(error))
                    : observer.onNext([])
                } else {
                    let userProfiles = snapshots?.documents.compactMap {
                        UserParser.parse($0.documentID, $0.data())
                    } ?? []
                    // userIdsの順にuserProfilesを並べ替える
                    let sortedUserProfiles = userIds.compactMap { userId in
                        userProfiles.first(where: { $0.userId == userId })
                    }
                    observer.onNext(sortedUserProfiles)
                }
            }
            return Disposables.create()
        }
    }
    
    // ページネーションで追加データ取得 lastDocument: 現在表示中の一番古いドキュメント
    func fetchMoreUserIdsInLocation(locationId: String, limit: Int, oldestDocument: QueryDocumentSnapshot?) -> Observable<(userIds: [String], oldestDocument: QueryDocumentSnapshot?)> {
        Observable.create { observer in
            guard let oldestDocument = oldestDocument else {
                return Disposables.create()
            }

            // 前回取得の最後のドキュメント以降のデータ
            let query = self.firebaseConfig.usersInLocationsReference(with: locationId)
                .order(by: "createdAt", descending: true)
                .start(afterDocument: oldestDocument)
                .limit(to: limit)
            
            query.getDocuments { snapshots, error in
                if let error = error {
                    observer.onError(MyAppError.fetchMoreUserProfilesFailed(error))
                    print("ページネーションによる追加データ取得エラー発生 エラー内容: \(error)")
                } else {
                    // ユーザーのuuidを取得
                    let userIds: [String] = snapshots?.documents.compactMap { $0.documentID } ?? []
                    
                    if !userIds.isEmpty {
                        let oldestDocument = snapshots?.documents.last // 最後のスナップショットを保持
                        observer.onNext((userIds: userIds, oldestDocument: oldestDocument))
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    // ロケーションに参加する他ユーザーをリアルタイムリッスン
    func listenForNewUsersParticipation(locationId: String) -> Observable<[String]> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }

            // 初期値を現在時刻に設定
            let latestLoadedDocDate: Timestamp = Timestamp(date: Date())
            
            self.setupListenerForNewUsersParticipation(locationId: locationId, latestLoadedDocDate: latestLoadedDocDate, onDataChange: { userIds in
                observer.onNext(userIds)
            })
            
            return Disposables.create {
                self.listenerForNewUsersParticipation?.remove()
            }
        }
    }

    // ロケーションに参加する他ユーザーをリアルタイムリッスン
    func listenForNewUsersParticipation(locationId: String, latestLoadedDocDate: Timestamp) -> Observable<(userIds: [String], latestLoadedDocDate: Timestamp)> {
        Observable.create { observer in
            let query = self.firebaseConfig.usersInLocationsReference(with: locationId)
                .order(by: "createdAt")
                .start(after: [latestLoadedDocDate]) // 最後のデータ以降のみ取得（？）
                .limit(to: 3) // 最新データ3件までリッスン
            
            self.listenerForNewUsersParticipation = query.addSnapshotListener { snapshots, error in
                if let error = error {
                    print("ロケーションに参加する他ユーザーの情報取得エラー発生 エラー内容: \(error)")
                } else if let documents = snapshots?.documents, !documents.isEmpty {
                    // ユーザーのuuidを取得
                    let userIds: [String] = documents.compactMap { $0.documentID }
                    let latestDocument = documents.last // 最後のスナップショットを保持
                    let data = latestDocument?.data()
                    let date = data?["createdAt"] as? Timestamp
                    observer.onNext((userIds: userIds, latestLoadedDocDate: date!))
                }
            }
            return Disposables.create()
        }
    }
    
    // 退出したユーザーをリッスン
    func listenForUsersExit(locationId: String) -> Observable<[String]> {
        Observable.create { observer in
            let query = self.firebaseConfig.usersInLocationsReference(with: locationId)
            
            self.listenerForUsersExit = query.addSnapshotListener { snapshots, error in
                if let error = error {
                    print("退出したユーザーの検知エラー発生 エラー内容: \(error)")
                } else if let documents = snapshots?.documentChanges, !documents.isEmpty {
                    var userIds: [String] = []
                    
                    for change in documents {
                        // 退出したユーザーを検知
                        if change.type == .removed {
                            let userId = change.document.documentID
                            userIds.append(userId)
                        }
                    }
                    observer.onNext(userIds)
                }
            }
            return Disposables.create()
        }
    }
    
    // 勉強部屋からの退出時、ユーザーIDドキュメントを削除＆参加ユーザー数を-1デクリメント
    func removeUserIdFromLocation(locationId: String) -> Observable<Void> {
        Observable.create { observer in
            guard let userId = FBAuth.currentUserId else {
                observer.onError(MyAppError.removeUserIdFromLocationFailed(nil))
                return Disposables.create()
            }
            
            // ユーザーIDドキュメントを削除
            self.firebaseConfig.usersInLocationsReference(with: locationId).document(userId)
                .delete { error in
                    if let error = error {
                        observer.onError(MyAppError.removeUserIdFromLocationFailed(error))
                    } else {
                        // userCount フィールドを -1 デクリメント
                        let locationRef = self.firebaseConfig.locationsCollectionReference().document(locationId)
                        locationRef.updateData([
                            "userCount": FieldValue.increment(Int64(-1))  // userCountを-1デクリメント
                        ]) { error in
                            if let error = error {
                                observer.onError(MyAppError.decrementUserCountFailed(error))
                            } else {
                                observer.onNext(())
                                observer.onCompleted()
                            }
                        }
                    }
                }
            return Disposables.create()
        }
    }
    
    // 勉強部屋からの退出時、勉強時間（時間＆分数単位）、必要な合計勉強時間、報酬コインを更新
    func saveStudyProgressAndRewards(locationId: String, updatedData: VisitedLocation) -> Observable<Void> {        Observable.create { observer in
            guard let userId = FBAuth.currentUserId else {
                observer.onError(MyAppError.userNotFound)
                return Disposables.create()
            }
            
            let dicData = updatedData.toDictionary
            self.firebaseConfig.visitedCollectionReference(with: userId).document(locationId)
                .setData(dicData, merge: true) { error in
                    if let error = error {
                        observer.onError(MyAppError.saveStudyProgressAndRewardsFailed(error))
                    } else {
                        observer.onNext(())
                        observer.onCompleted()
                    }
                }
            return Disposables.create()
        }
    }
    
    // 所持金に報酬コインを加算
    func updateCurrentCoin(addedRewardCoin: Int) -> Observable<Void> {
        Observable.create { observer in
            guard let userId = FBAuth.currentUserId else {
                observer.onError(MyAppError.userNotFound)
                return Disposables.create()
            }
            
            let dicData = [
                "currentCoin": FieldValue.increment(Int64(addedRewardCoin))
            ]
            
            let docRef = self.firebaseConfig.usersCollectionReference().document(userId)
            docRef.updateData(dicData) { error in
                if let error = error {
                    observer.onError(MyAppError.updateCurrentCoinFailed(error))
                } else {
                    observer.onNext(())
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}

extension MainService {
    
    // お試し利用中か否か
    private var isTrialUse: Bool { FBAuth.currentUserId == MyAppSettings.userIdForTrial }
   
    private func setupListenerForNewUsersParticipation(
        locationId: String,
        latestLoadedDocDate: Timestamp,
        onDataChange: @escaping ([String]) -> Void
    ) {
        var latestLoadedDocDate: Timestamp = latestLoadedDocDate
        // 以前のリスナーを停止
        self.listenerForNewUsersParticipation?.remove()
        
        let query = self.firebaseConfig.usersInLocationsReference(with: locationId)
            .order(by: "createdAt")
            .start(after: [latestLoadedDocDate])
            .limit(to: 3)
        
        self.listenerForNewUsersParticipation = query.addSnapshotListener { snapshots, error in
            if let error = error {
                print("ロケーションに参加する他ユーザーの情報取得エラー発生 エラー内容: \(error)")
                return
            }
            else if let documents = snapshots?.documents, !documents.isEmpty {

                if let latestDocument = documents.last,
                   let latestTimestamp = latestDocument.data()["createdAt"] as? Timestamp {
                    // ドキュメントの最新取得日を更新
                    latestLoadedDocDate = latestTimestamp
                    
                    // ユーザーのuuidを取得
                    let userIds: [String] = documents.compactMap { $0.documentID }
                    // 最新の順番に並べる
                    let reversedUserIds: [String] = userIds.reversed()
                    onDataChange(reversedUserIds)
                    
                    // 再度リッスンを設定
                    self.setupListenerForNewUsersParticipation(locationId: locationId, latestLoadedDocDate: latestLoadedDocDate, onDataChange: onDataChange)
                }
            } else {
                print("日付が「\(latestLoadedDocDate.dateValue().timeIntervalSince1970)」より後のドキュメントが存在しません。")
            }
        }
    }
}
