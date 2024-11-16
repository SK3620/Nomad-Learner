//
//  AuthServiceProtocol.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/02.
//

import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth

protocol AuthServiceProtocol {
    // サインイン
    func signIn(email: String, password: String, shouldReauthenticate: Bool) -> Observable<Void>
    // サインアップ
    func signUp(username: String, email: String, password: String) -> Observable<FirebaseAuth.User>
    // パスワード再設定メール
    func sendPasswordRest(with email: String) -> Observable<Void>
    // アカウント削除
    func deleteAccount(email: String, password: String) -> Observable<Void>
    // UserIDの存在確認
    func checkUUIDExists(with userId: String) -> Observable<Bool>
}

final class AuthService: AuthServiceProtocol {
    
    public static let shared = AuthService()
    
    private let firebaseConfig = FirebaseConfig.shared
    
    private init() {}
    
    // サインアップ
    func signUp(username: String, email: String, password: String) -> Observable<FirebaseAuth.User> {
        return Observable<FirebaseAuth.User>.create { observer in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let user = authResult?.user {
                    // usernameをuserに保存する
                    let req = user.createProfileChangeRequest()
                    req.displayName = username
                    req.commitChanges(completion: { (error) in
                        if let error = error {
                            observer.onError(MyAppError.signUpFailed(error))
                        } else {
                            observer.onNext(user)
                            observer.onCompleted()
                        }
                    })
                } else if let error = error {
                    observer.onError(MyAppError.signInFailed(error))
                } else {
                    observer.onError(MyAppError.unknown)
                }
            }
            return Disposables.create()
        }
    }
    
    // サインイン（アカウント削除時は再認証が必要）
    func signIn(email: String, password: String, shouldReauthenticate: Bool) -> Observable<Void> {
        return Observable<Void>.create { observer in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let _ = authResult?.user {
                    observer.onNext(())
                    observer.onCompleted()
                } else if let error = error {
                    let myAppError = shouldReauthenticate
                    ? MyAppError.reauthenticateFailed
                    : MyAppError.signInFailed(error)
                    observer.onError(myAppError)
                } else {
                    observer.onError(MyAppError.unknown)
                }
            }
            return Disposables.create()
        }
    }
    
    // パスワードリセット（現在不使用）
    func sendPasswordRest(with email: String) -> Observable<Void> {
        Observable<Void>.create { observer in
            Auth.auth().sendPasswordReset(withEmail: email, completion:  { error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        }
    }
    
    // アカウント削除
    func deleteAccount(email: String, password: String) -> Observable<Void> {
        return Observable<Void>.create { observer in
            if email.isEmpty || password.isEmpty {
                observer.onError(MyAppError.deleteAccount(.fieldEmpty))
            }
            
            if let user = FBAuth.currentUser {
                // アカウントの削除を実行
                user.delete { error in
                    if let error = error {
                        observer.onError(MyAppError.deleteAccount(.deleteAccountFailed(error)))
                    } else {
                        observer.onNext(()) // アカウント削除成功
                        observer.onCompleted()
                    }
                }
            } else {
                observer.onError(MyAppError.deleteAccount(.deleteAccountFailed(nil)))
            }
            return Disposables.create()
        }
    }
    
    // UserIDの存在確認
    func checkUUIDExists(with userId: String) -> Observable<Bool> {
        return Observable.create { observer in
            let docRef = self.firebaseConfig.usersCollectionReference().whereField("userId", isEqualTo: userId)
            docRef.getDocuments { snapshots, error in
                if let error = error {
                    observer.onError(MyAppError.signInFailed(error))
                } else {
                    let exists = snapshots?.documents.isEmpty == false
                    observer.onNext(exists)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
