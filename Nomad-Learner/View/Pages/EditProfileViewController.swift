//
//  EditProfileViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/10.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa
import CLImageEditor
import KRProgressHUD

class EditProfileViewController: UIViewController, AlertEnabled, KRProgressHUDEnabled {
    
    var userProfile: User
    
    private lazy var editProfileView: EditProfileView = EditProfileView()
    
    private let tapGesture = UITapGestureRecognizer()
    
    private var viewModel: EditProfileViewModel!
    
    // プロフィール画像を保持
    private let profileImageRelay = BehaviorRelay<UIImage?>(value: nil)
    
    private let disposeBag = DisposeBag()
    
    init(userProfile: User) {
        self.userProfile = userProfile
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
        update()
    }
    
    private func setupUI() {
        view.backgroundColor = ColorCodes.primaryPurple.color()
        
        view.addGestureRecognizer(tapGesture)
        view.addSubview(editProfileView)
        
        editProfileView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        self.viewModel = EditProfileViewModel(
            input:
                (
                    username: editProfileView.usernameTextView.rx.text.orEmpty.asDriver(),
                    livingPlaceAndWork: editProfileView.livingPlaceAndWorkTextView.rx.text.orEmpty.asDriver(),
                    studyContent: editProfileView.studyContentTextView.rx.text.orEmpty.asDriver(),
                    goal: editProfileView.goalTextView.rx.text.orEmpty.asDriver(),
                    saveButtonTaps: editProfileView.navigationBar.saveButton.rx.tap.asSignal(),
                    profileImage: profileImageRelay.asDriver()
                ),
            mainService: MainService.shared
        )
                        
        // ローディングインジケーター
        viewModel.isLoading
            .drive(self.rx.showProgress)
            .disposed(by: disposeBag)
        
        // プロフィール情報更新完了後、元のプロフィールを上書きしてマップ画面に戻る
        viewModel.didSaveUserProfile
            .compactMap { $0 } // nil（更新処理失敗）の場合は処理を止める
            .drive(backToMapVC)
            .disposed(by: disposeBag)
        
        // エラーダイアログ表示
        viewModel.myAppError
            .map { AlertActionType.error($0) }
            .drive(self.rx.showAlert)
            .disposed(by: disposeBag)
        
        // プロフィール画面に戻る
        editProfileView.navigationBar.closeButton.rx.tap
            .bind(to: backToProfileVC)
            .disposed(by: disposeBag)
        
        // 画像ライブラリを開く
        editProfileView.addPictureButton.rx.tap
            .bind(to: handleLibrary)
            .disposed(by: disposeBag)
        
        // デフォルト画像を適用
        editProfileView.applyDefaultPictureButton.rx.tap
            .bind(to: applyDefaultProfileImage)
            .disposed(by: disposeBag)
    }
    
    // Profile情報を各UIに反映
    private func update() {
        editProfileView.update(with: userProfile, completion: { [weak self] currentImage in
            guard let self = self else { return }
            // 現在のプロフィール画像データを流す
            self.profileImageRelay.accept(currentImage)
        })
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditProfileViewController {
    // ProfileVC（プロフィール画面に戻る）
    private var backToProfileVC: Binder<Void> {
        return Binder(self) { base, _ in
            Router.dismissModal(vc: self)
        }
    }
    // MapVC（マップ画面に戻る）
    private var backToMapVC: Binder<User> {
        return Binder(self) { base, inputUserProfile in
            // 編集したプロフィール情報で上書きして渡す
            var updatedUserProfile = base.userProfile
            updatedUserProfile.username = inputUserProfile.username
            updatedUserProfile.profileImageUrl = inputUserProfile.profileImageUrl
            updatedUserProfile.livingPlaceAndWork = inputUserProfile.livingPlaceAndWork
            updatedUserProfile.studyContent = inputUserProfile.studyContent
            updatedUserProfile.goal = inputUserProfile.goal
            
            KRProgressHUD.dismiss()
            
            Router.backToMapVC(vc: self, updatedUserProfile)
        }
    }
    
    // 画像ライブラリを開く
    private var handleLibrary: Binder<Void> {
        return Binder(self) {base, _ in
            // ライブラリ（カメラロール）を指定してピッカーを開く
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let pickerController = UIImagePickerController()
                pickerController.delegate = base
                pickerController.sourceType = .photoLibrary
                self.present(pickerController, animated: true, completion: nil)
            }
        }
    }
    
    // デフォルト画像を適用（nilに設定）
    private var applyDefaultProfileImage: Binder<Void> {
        return Binder(self) { base, _ in
            base.editProfileView.pictureImageView.image = UIImage(named: "Globe")
            base.profileImageRelay.accept(nil)
        }
    }
}

// 画像ライブラリ操作
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate {
    // 写真を撮影/選択したときに呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.allowsEditing = true
        if info[.originalImage] != nil {
            // 撮影/選択された画像を取得する
            let image = info[.originalImage] as! UIImage
            // CLImageEditorライブラリで加工する
            print("DEBUG_PRINT: image = \(image)")
            // CLImageEditorにimageを渡して、加工画面を起動する。
            let editor = CLImageEditor(image: image)!
            editor.delegate = self
            editor.modalPresentationStyle = .fullScreen
            picker.present(editor, animated: true, completion: nil)
        }
    }
            
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // UIImagePickerController画面を閉じる
        picker.dismiss(animated: true)
    }

    // CLImageEditorで加工が終わったときに呼ばれるメソッド
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
        // プロフィール画像に選択した画像をセット
        editProfileView.pictureImageView.image = image
        // viewModelへ画像を渡す
        profileImageRelay.accept(image)
        editor.dismiss(animated: true)
    }

    // CLImageEditorの編集がキャンセルされた時に呼ばれるメソッド
    func imageEditorDidCancel(_ editor: CLImageEditor!) {
        // CLImageEditor画面を閉じる
        editor.dismiss(animated: true)
    }
}

extension EditProfileViewController {
    
    // 自動的に回転を許可するか（デフォルト値: true）
    override var shouldAutorotate: Bool {
       return false
    }
    
    // 回転の向き
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

