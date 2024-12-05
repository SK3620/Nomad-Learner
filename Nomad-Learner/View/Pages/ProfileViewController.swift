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
import MessageUI

class ProfileViewController: UIViewController {
    
    // ユーザープロフィール情報
    var userProfile: User
    
    // 画面が縦向きか横向きか
    var orientation: ScreenOrientation
    
    private let tapGesture = UITapGestureRecognizer()
    
    private let disposeBag = DisposeBag()
    
    // ユーザープロフィール情報を渡す
    private lazy var profileView: ProfileView = ProfileView(orientation: self.orientation, with: self.userProfile)
    
    // カスタムイニシャライザ
    init(orientation: ScreenOrientation, with userProfile: User) {
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
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.height.equalToSuperview().multipliedBy(0.55)
                // 横向き
            } else if orientation == .landscape {
                $0.verticalEdges.equalToSuperview().inset(20)
                $0.width.equalTo(view.viewHeight - 32)
            }
        }
        
        // StudyRommVC（勉強部屋画面）の場合は編集ボタン非表示＆報告ボタン表示
        let isLandscape = (orientation == .landscape)
        profileView.navigationBar.editButton.isHidden = isLandscape
        profileView.navigationBar.reportButton.isHidden = !isLandscape
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
        
        // 報告
        profileView.navigationBar.reportButton.rx.tap
            .withLatestFrom(Observable.just(userProfile))
            .bind(to: report)
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

extension ProfileViewController: MFMailComposeViewControllerDelegate, AlertEnabled {
    private var report: Binder<User> {
        return Binder(self) { base, userProfile in
            if MFMailComposeViewController.canSendMail() == false {
                print("Email Send Failed")
                return
            }

            guard let userEmail = FBAuth.currentUserEmail else {
                print("メールアドレスの取得失敗")
                return
            }

            let mailViewController = MFMailComposeViewController()
            let toRecipients = [MyAppSettings.developerEmail]
            let CcRecipients = [userEmail]
            let BccRecipients = [userEmail]

            mailViewController.mailComposeDelegate = self
            let text = "【通報】ユーザー名：\(userProfile.username)" + "\n" + "ユーザーID：\(userProfile.userId)"
            mailViewController.setToRecipients(toRecipients) // 宛先メールアドレスの表示
            mailViewController.setCcRecipients(CcRecipients)
            mailViewController.setBccRecipients(BccRecipients)
            mailViewController.setMessageBody(text + "\n" + "内容：(ex.プロフィール内容が不適切。○○さんのプロフィール画像が不快。等）", isHTML: false)
            mailViewController.title = "【通報】"

            self.present(mailViewController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
        var alertActionType: AlertActionType?
        switch result {
        case .cancelled:
            alertActionType = .didCancelMail()
        case .saved:
            alertActionType = .didSaveMail()
        case .sent:
            alertActionType = .didSendMail()
        case .failed:
            alertActionType = .error(.mailSendFailed(error))
        default:
            break
        }
        // アラート表示
        self.rx.showAlert.onNext(alertActionType!)
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
