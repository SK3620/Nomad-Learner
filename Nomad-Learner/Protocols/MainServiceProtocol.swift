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
    func fetchUserIdsInLocation(locationId: String, limit: Int) -> Observable<(userIds: [String], latestLoadedDocDate: Timestamp?, oldestDocument: QueryDocumentSnapshot?)>
    // ロケーションに参加中のユーザーのプロフィール情報を取得
    func fetchUserProfiles(userIds: [String]) -> Observable<[User]>
    // ページネーションで追加データ取得
    func fetchMoreUserIdsInLocation(locationId: String, limit: Int, oldestDocument: QueryDocumentSnapshot?) -> Observable<(userIds: [String], oldestDocument: QueryDocumentSnapshot?)>
    // ロケーションに参加する他ユーザーをリアルタイムリッスン
    func listenForNewUsersParticipation(locationId: String, latestLoadedDocDate: Timestamp) -> Observable<(userIds: [String], latestLoadedDocDate: Timestamp)>
    // 勉強部屋から退出
    func removeUserIdFromLocation(locationId: String) -> Observable<Void>
    // 勉強部屋からの退出時、合計勉強時間、ミッション勉強時間、報酬コインを保存
    func saveStudyProgressAndRewards(locationId: String, updatedData: VisitedLocation) -> Observable<Void>
}

final class MainService: MainServiceProtocol {
    
    public static let shared = MainService()
    
    private let firebaseConfig = FirebaseConfig.shared
    
    private init(){}
    
    // マップのマーカーに設定するロケーション情報取得
    func fetchFixedLocations() -> Observable<[FixedLocation]> {
        return Observable.create { observer in
            self.firebaseConfig.fixedLocationsReference().observe(.value) { snapshot in
                if !snapshot.exists() {
                    observer.onError(MyAppError.locationEmpty)
                }
                
                var locations = [FixedLocation]()
                // Firebaseのスナップショットからデータを抽出し、FixedLocationに変換
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let locationData = childSnapshot.value as? [String: Any],
                       let location = FixedLocationParser.parse(childSnapshot.key, locationData)
                    {
                        locations.append(location)
                    }
                }
                observer.onNext(locations)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    // プロフィール画像保存
    func saveProfileImage(image: UIImage) -> Observable<String> {
        return Observable.create { observer in
            guard let userId = FBAuth.currentUserId else {
                observer.onError(MyAppError.userNotFound(nil))
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
                    observer.onError(MyAppError.allError(error))
                }
                else if let _ = metadata {
                    profileImageRef.downloadURL { url, error in
                        if let error = error {
                            observer.onError(MyAppError.allError(error))
                        }
                        if let downloadUrl = url {
                            observer.onNext(downloadUrl.absoluteString)
                        } else {
                            observer.onError(MyAppError.allError(error))
                        }
                    }
                } else {
                    observer.onError(MyAppError.allError(nil))
                }
            }
            return Disposables.create()
        }
    }
    
    // ユーザープロフィール保存
    func saveUserProfile(user: User, shouldUpdate: Bool = false) -> Observable<Void> {
        return Observable.create { observer in
            guard let userId = FBAuth.currentUserId else {
                observer.onError(MyAppError.userNotFound(nil))
                return Disposables.create()
            }
            
            var userData: [String: Any] = [:]
            if shouldUpdate {
                userData = user.toDictionary2
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
                observer.onError(MyAppError.userNotFound(nil))
                return Disposables.create()
            }
            // Firestoreからユーザーデータを取得
            self.firebaseConfig.usersCollectionReference().document(userId).getDocument { document, error in
                if let error = error {
                    observer.onError(MyAppError.fetchUserProfileFailed(error))
                } else if let document = document, document.exists, let userData = document.data() {
                    // データをUserモデルに変換
                    if let fetchedUser = UserParser.parse(userData) {
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
                observer.onError(MyAppError.userNotFound(nil))
                return Disposables.create()
            }
            
            self.firebaseConfig.visitedCollectionReference(with: userId).getDocuments { snapshots, error in
                if let error = error {
                    observer.onError(MyAppError.fetchVisitedLocationsFailed(error))
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
                    observer.onError(MyAppError.allError(error))
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
                observer.onError(MyAppError.userNotFound(nil))
                return Disposables.create()
            }
            
            let updatedData = [
                "currentCoin": currentCoin,
                "currentLocationId": locationId
            ]
                        
            self.firebaseConfig.usersCollectionReference().document(userId)
                .updateData(updatedData) { error in
                    if let error = error {
                        // フィールド更新失敗
                        observer.onError(MyAppError.allError(error))
                    } else {
                        observer.onNext(())
                        observer.onCompleted()
                    }
                }
            return Disposables.create()
        }
    }
    
    // 参加中のロケーションにuuidを追加
    func addUserIdToLocation(locationId: String) -> Observable<Void> {
        Observable.create { observer in
            guard let userId = FBAuth.currentUserId else {
                observer.onError(MyAppError.userNotFound(nil))
                return Disposables.create()
            }
            
            let data: [String: Any] = [
                "createdAt": FieldValue.serverTimestamp()
            ]
            self.firebaseConfig.usersInLocationsReference(with: locationId).document(userId).setData(data) { error in
                if let error = error {
                    observer.onError(MyAppError.allError(error))
                } else {
                    observer.onNext(())
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    // ロケーションに参加中のユーザーのuuidを取得（初回読み込み）
    func fetchUserIdsInLocation(locationId: String, limit: Int) -> Observable<(userIds: [String], latestLoadedDocDate: Timestamp?, oldestDocument: QueryDocumentSnapshot?)> {
        Observable.create { observer in
            let query = self.firebaseConfig.usersInLocationsReference(with: locationId)
                .order(by: "createdAt", descending: true)
                .limit(to: limit) // 最新の指定件数を取得
            
            query.getDocuments { snapshots, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    // ユーザーのuuidを取得
                    let userIds: [String] = snapshots?.documents.compactMap { $0.documentID } ?? []
                    let latestLoadedDocDate = snapshots?.documents.first?.data()["createdAt"] as? Timestamp // 最新のドキュメントのTimeStampを取得
                    let oldestDocument = snapshots?.documents.last // 一番古いドキュメントを取得
                    observer.onNext((userIds: userIds, latestLoadedDocDate: latestLoadedDocDate, oldestDocument: oldestDocument))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    // ロケーションに参加中のユーザーのプロフィール情報を取得
    func fetchUserProfiles(userIds: [String]) -> Observable<[User]> {
        Observable.create { observer in
            guard !userIds.isEmpty else {
                // 一人以上は存在しないといけない
                observer.onError(MyAppError.allError(nil))
                return Disposables.create()
            }
            
            let query = self.firebaseConfig.usersCollectionReference()
                .whereField(FieldPath.documentID(), in: [userIds])
            
            query.getDocuments { snapshots, error in
                if let error = error {
                    observer.onError(MyAppError.allError(error))
                } else {
                    let userProfiles = snapshots?.documents.compactMap {
                        UserParser.parse($0.data())
                    } ?? []
                    
                    observer.onNext(userProfiles)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    // ページネーションで追加データ取得 lastDocument: 現在表示中の一番古いドキュメント
    func fetchMoreUserIdsInLocation(locationId: String, limit: Int, oldestDocument: QueryDocumentSnapshot?) -> Observable<(userIds: [String], oldestDocument: QueryDocumentSnapshot?)> {
        Observable.create { observer in
            guard let oldestDocument = oldestDocument else {
                // lastDocumentがない
                observer.onError(MyAppError.allError(nil))
                return Disposables.create()
            }
            
            // 前回取得の最後のドキュメント以降のデータ
            let query = self.firebaseConfig.usersInLocationsReference(with: locationId)
                .order(by: "createdAt", descending: true)
                .limit(to: limit)
                .start(afterDocument: oldestDocument)
            
            query.getDocuments { snapshots, error in
                if let error = error {
                    observer.onError(MyAppError.allError(error))
                } else {
                    // ユーザーのuuidを取得
                    let userIds: [String] = snapshots?.documents.compactMap { $0.documentID } ?? []
                    let oldestDocument = snapshots?.documents.last // 最後のスナップショットを保持
                    observer.onNext((userIds: userIds, oldestDocument: oldestDocument))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    // ロケーションに参加する他ユーザーをリアルタイムリッスン
    func listenForNewUsersParticipation(locationId: String, latestLoadedDocDate: Timestamp) -> Observable<(userIds: [String], latestLoadedDocDate: Timestamp)> {
        Observable.create { observer in
            let query = self.firebaseConfig.usersInLocationsReference(with: locationId)
                .order(by: "createdAt")
                .start(after: [latestLoadedDocDate]) // 最後のデータ以降のみ取得（？）
                .limit(to: 3) // 最新データ3件までリッスン
            
            query.addSnapshotListener { snapshots, error in
                if let error = error {
                    observer.onError(MyAppError.allError(error))
                } else {
                    // ユーザーのuuidを取得
                    let userIds: [String] = snapshots?.documents.compactMap { $0.documentID } ?? []
                    let latestDocument = snapshots?.documents.last // 最後のスナップショットを保持
                    let data = latestDocument?.data()
                    let date = data?["createdAt"] as? Timestamp // あとで修正すること！
                    observer.onNext((userIds: userIds, latestLoadedDocDate: date!))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    // 勉強部屋からの退出時、ユーザーIDドキュメントを削除
    func removeUserIdFromLocation(locationId: String) -> Observable<Void> {
        Observable.create { observer in
            guard let userId = FBAuth.currentUserId else {
                observer.onError(MyAppError.userNotFound(nil))
                return Disposables.create()
            }
            
            self.firebaseConfig.usersInLocationsReference(with: locationId).document(userId)
                .delete { error in
                    if let error = error {
                        observer.onError(MyAppError.allError(error))
                    } else {
                        observer.onNext(())
                        observer.onCompleted()
                    }
                }
            return Disposables.create()
        }
    }
    
    // 勉強部屋からの退出時、勉強時間（時間＆分数単位）、必要な合計勉強時間、報酬コインを更新
    func saveStudyProgressAndRewards(locationId: String, updatedData: VisitedLocation) -> Observable<Void> {        Observable.create { observer in
            guard let userId = FBAuth.currentUserId else {
                observer.onError(MyAppError.userNotFound(nil))
                return Disposables.create()
            }
            
            let dicData = updatedData.toDictionary
            self.firebaseConfig.visitedCollectionReference(with: userId).document(locationId)
                .setData(dicData, merge: true) { error in
                    if let error = error {
                        observer.onError(MyAppError.allError(error))
                    } else {
                        observer.onNext(())
                        observer.onCompleted()
                    }
                }
            return Disposables.create()
        }
    }
}
