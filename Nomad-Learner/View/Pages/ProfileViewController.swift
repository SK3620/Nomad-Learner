//
//  ProfileViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/09.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa
import Then
import SnapKit

class ProfileViewController: UIViewController {
    
    // ユーザープロフィール情報
    var userProfile: User
    
    // 画面が縦向きか横向きか
    var orientation: ScreenOrientation
    
    private let tapGesture = UITapGestureRecognizer()
    
    private let disposeBag = DisposeBag()
    
    // ユーザープロフィール情報を渡す
    private lazy var profileView: ProfileView = ProfileView(userProfile: self.userProfile)
    
    // カスタムイニシャライザ
    init(orientation: ScreenOrientation = .portrait, with userProfile: User) {
        self.orientation = orientation
        self.userProfile = userProfile
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UIセットアップ
        setupUI()
        // バインディング
        bind()
    }
    
    private func setupUI() {
        view.backgroundColor = ColorCodes.modalBackground.color()
        
        view.addGestureRecognizer(tapGesture)
        view.addSubview(profileView)
        
        profileView.snp.makeConstraints {
            $0.center.equalToSuperview()
            // 縦向き
            if orientation == .portrait {
                $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.semiMediumPadding)
                $0.height.equalToSuperview().multipliedBy(0.55)
                // 横向き
            } else if orientation == .landscape {
                $0.verticalEdges.equalToSuperview().inset(UIConstants.Layout.semiMediumPadding)
                $0.width.equalToSuperview().multipliedBy(0.45)
            }
        }
        
        // StudyRommVC（勉強部屋画面）の場合は編集ボタン非表示
        profileView.navigationBar.editButton.isHidden = (orientation == .landscape)
    }
}

extension ProfileViewController: KRProgressHUDEnabled {
    private func bind() {
        
        // MapVCへ戻る
        tapGesture.rx.event
            .map { [weak self] sender in
                guard let self = self else { return false }
                let tapLocation = sender.location(in: sender.view)
                return !self.profileView.frame.contains(tapLocation)
            }
            .filter { $0 } // 枠外タップ（true）のみ処理
            .map { _ in () }
            .bind(to: backToMapVC)
            .disposed(by: disposeBag)
        
        // 開発中の機能であることを表示
        profileView.profileBottomView.inDevelopmentButton.rx.tap
            .map { _ in ProgressHUDMessage.inDevelopment2 }
            .bind(to: self.rx.showMessage)
            .disposed(by: disposeBag)
        
        // MapVCへ戻る
        profileView.navigationBar.closeButton.rx.tap
            .bind(to: self.backToMapVC)
            .disposed(by: disposeBag)
        
        // EditProfileVCへ遷移
        profileView.navigationBar.editButton.rx.tap
            .bind(to: self.toEditProfileVC)
            .disposed(by: disposeBag)
    }
}

extension ProfileViewController {
    // MapVC（マップ画面）へ戻る
    private var backToMapVC: Binder<Void> {
        return Binder(self) { base, _ in Router.dismissModal(vc: self) }
    }
    // EditProfileVC（編集画面）へ遷移
    private var toEditProfileVC: Binder<Void> {
        return Binder(self) { base, _ in Router.showEditProfile(vc: base, with: base.userProfile) }
    }
}

extension ProfileViewController {
    
    // 自動的に回転を許可するか（デフォルト値: true）
    override var shouldAutorotate: Bool {
       return false
    }
    
    // 回転の向き
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return orientation == .portrait ? .portrait : .landscape
    }
}
