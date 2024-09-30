//
//  AuthViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/09/26.
//

import UIKit
import SwiftUI
import SnapKit
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FirebaseOAuthUI
import Firebase
import Then

class AuthViewController: UIViewController, FUIAuthDelegate {
    
    private let authUI = FUIAuth.defaultAuthUI()!
    
    // 各認証プロバイダ
    private lazy var providers: [FUIAuthProvider] = [
        FUIGoogleAuth(authUI: authUI),
        FUIOAuth.appleAuthProvider(withAuthUI: authUI),
        FUIOAuth.twitterAuthProvider(withAuthUI: authUI)
    ]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupFirebaseUI()
    }
    
    // MARK: - Set up UI
    private func setupFirebaseUI() {
        // キャンセル非表示
        authUI.shouldHideCancelButton = true
        // 値をセット
        authUI.providers = providers
        authUI.delegate = self
        
        // FirebaseUIのauthViewControllerを取得
        let authViewController = authUI.authViewController()
        addChild(authViewController)
        view.addSubview(authViewController.view)
        authViewController.didMove(toParent: self)
        
        // セーフエリア内に設置
        authViewController.view.snp.makeConstraints {
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.snp.horizontalEdges)
        }
    }
    
    // カスタムAuthPickerViewControllerを適用
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        return CustomAuthPickerViewController(authUI: authUI)
    }
}

extension AuthViewController {
    // 認証結果を受け取る際に呼ばれる
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: (any Error)?) {
        if let user = user {
            print("Sign in successfully: \(user)")
        }
        
        if let error = error {
            print("Failed to sign in: \(error)")
        }
    }
}

struct ViewControllerPreview: PreviewProvider {
    struct Wrapper: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            UINavigationController(rootViewController: AuthViewController())
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
    static var previews: some View {
        Wrapper()
    }
}

