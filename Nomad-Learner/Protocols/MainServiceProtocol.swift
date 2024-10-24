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
    func saveUserProfile(user: User) -> Observable<Void>
    // ユーザープロフィール取得
    func fetchUserProfile() -> Observable<User>
    // 訪問したロケーション情報を取得
    func fetchVisitedLocations() -> Observable<[VisitedLocation]>
}

final class MainService: MainServiceProtocol {
    
    public static let shared = MainService()
    
    private let firebaseConfig = FirebaseConfig.shared
    
    private init(){}
    
    // マップのマーカーに設定するロケーション情報取得
    func fetchFixedLocations() -> Observable<[FixedLocation]> {
        return Observable.create { observer in
            self.firebaseConfig.locationsReference().observe(.value) { snapshot in
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
    func saveUserProfile(user: User) -> Observable<Void> {
        return Observable.create { observer in
            // 辞書型に変換
            let userData: [String: Any] = user.toDictionary
            
            // AuthのUUIDを取得
            if let userId = FBAuth.currentUserId {
                // Firestoreにユーザー情報を保存
                self.firebaseConfig.usersCollectionReference().document(userId).setData(userData) { error in
                    if let error = error {
                        observer.onError(MyAppError.saveUserProfileFailed(error))
                    } else {
                        observer.onNext(())
                        observer.onCompleted()
                    }
                }
            } else {
                observer.onError(MyAppError.userNotFound(nil))
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
            
            self.firebaseConfig.visitedCollectionReference(with: userId).getDocuments { snapshot, error in
                if let error = error {
                    observer.onError(MyAppError.fetchVisitedLocationsFailed(error))
                } else {
                    let locations = snapshot?.documents.compactMap { VisitedLocationParser.parse($0.documentID, $0.data())} ?? []
                    
                    observer.onNext(locations)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
