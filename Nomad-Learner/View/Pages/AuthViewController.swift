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
import RxSwift

class AuthViewController: UIViewController {
    
    private let authUI = FUIAuth.defaultAuthUI()!
    
    private lazy var customAuthPickerViewController = CustomAuthPickerViewController(authUI: self.authUI)
    
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
        return customAuthPickerViewController
    }
}

extension AuthViewController: FUIAuthDelegate {
    //認証結果を受け取る際に呼ばれる関数
    func authUI(_ authUI: FUIAuth, didSignInWith user: FirebaseAuth.User?, error: Error?) {
        // ViewModelで処理
        customAuthPickerViewController.viewModel.handleSignInWithAuthProviderResult(user: user, error: error)
    }
}

extension AuthViewController {
    // customAuthPickerViewControllerを返すメソッドを追加
    func getCustomAuthPickerViewController() -> CustomAuthPickerViewController? {
        return customAuthPickerViewController
    }
}
