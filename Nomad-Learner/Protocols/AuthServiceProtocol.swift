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
    func signUp(username: String, email: String, password: String) -> Observable<User>
//    func signUp(username: String, email: String, password: String) -> Single<User>
}

final class AuthService: AuthServiceProtocol {
    
    func signUp(username: String, email: String, password: String) -> Observable<User> {
        return Observable<User>.create { observer in
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
    
    /*
    func signUp(username: String, email: String, password: String) -> Single<User> {
        Single<User>.create { observer in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let user = authResult?.user {
                    // ユーザープロフィール変更リクエスト
                    let req = user.createProfileChangeRequest()
                    // ユーザー名を設定
                    req.displayName = username
                    // 変更をサーバーに送信
                    req.commitChanges { error in
                        if let error = error {
                            observer(.failure(error))
                        } else {
                            observer(.success(user))
                        }
                    }
                } else if let error = error {
                    observer(.failure(error))
                } else {
                    observer(.failure(MyError.unknown))
                }
            }
            return Disposables.create()
        }
    }
     */
    
    
}
