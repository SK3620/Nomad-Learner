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
    // ログイン状態の確認
    func addStateDidChangeListener() -> Observable<Bool>
    // ログイン状態の確認リスナー破棄
    func removeStateDidChangeListener()
    // サインイン
    func signIn(email: String, password: String) -> Observable<FirebaseAuth.User>
    // サインアップ
    func signUp(username: String, email: String, password: String) -> Observable<FirebaseAuth.User>
    // パスワード再設定メール
    func sendPasswordRest(with email: String) -> Observable<Void>
}

final class AuthService: AuthServiceProtocol {
    
    public static let shared = AuthService()

    // ログイン状態確認リスナー
    private var handler: AuthStateDidChangeListenerHandle?

    private init() {}
    
    // ログイン状態確認リスナー破棄
    deinit { removeStateDidChangeListener() }
    
    // ログイン状態確認
    func addStateDidChangeListener() -> Observable<Bool> {
        Observable<Bool>.create { observer in
            self.handler = Auth.auth().addStateDidChangeListener { _, user in
                if let _ = user {
                    observer.onNext(true)
                } else {
                    observer.onNext(false)
                }
            }
            return Disposables.create()
        }
    }
    
    // ログイン状態確認リスナー破棄
    func removeStateDidChangeListener() {
        if let handler = handler {
            Auth.auth().removeStateDidChangeListener(handler)
        }
    }
    
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
                            observer.onError(error)
                        } else {
                            observer.onNext(user)
                            observer.onCompleted()
                        }
                    })
                } else if let error = error {
                    observer.onError(error)
                } else {
                    observer.onError(MyError.unknown)
                }
            }
            return Disposables.create()
        }
    }
    
    // サインイン
    func signIn(email: String, password: String) -> Observable<FirebaseAuth.User> {
        return Observable<FirebaseAuth.User>.create { observer in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let user = authResult?.user {
                    observer.onNext(user)
                } else if let error = error {
                    observer.onError(error)
                } else {
                    observer.onError(MyError.unknown)
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
}
