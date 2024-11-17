//
//  EditProfileViewModel.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/10.
//

import Foundation
import RxSwift
import RxCocoa

class EditProfileViewModel {
    
    let didSaveUserProfile: Driver<User?>
    let isLoading: Driver<Bool>
    let myAppError: Driver<MyAppError>
    
    init(input: (
        username: Driver<String>,
        studyContent: Driver<String>,
        goal: Driver<String>,
        others: Driver<String>,
        saveButtonTaps: Signal<Void>,
        profileImage: Driver<UIImage?>
    ),
         currentUserProfile: User,
         mainService: MainServiceProtocol
    ) {
        // インジケーター
        let indicator = ActivityIndicator()
        self.isLoading = indicator.asDriver()
        
        // 入力したユーザーのプロフィール情報
        let userProfile = Driver.combineLatest(
            input.username,
            input.studyContent,
            input.goal,
            input.others,
            input.profileImage
        ) { username, studyContent, goal, others, profileImage in
            return User(
                username: !username.isEmpty ? username : "ー",
                studyContent: !studyContent.isEmpty ? studyContent : "ー",
                goal: !goal.isEmpty ? goal : "ー",
                others: !others.isEmpty ? others : "ー"
            )
        }
        
        // 更新するプロフィール情報
        var updatedUserProfile: User!
        
        // 保存ボタン押下後、保存処理を行う
        let saveUserProfileResult = input.saveButtonTaps
            .withLatestFrom(userProfile)
            .asObservable()
            .flatMapFirst { userProfile in
                updatedUserProfile = userProfile
                // 選択されたプロフィール画像がある場合、まず画像を保存する
                if let image = input.profileImage.unwrappedValue {
                    // Storageにプロフィール画像を保存
                    return mainService.saveProfileImage(image: image)
                        .flatMap { downloadUrlString in
                            // プロフィール画像をプリフェッチ
                            ImageCacheManager.prefetch(from: [URL(string: downloadUrlString)!])
                            // プロフィール画像ダウンロードURLを設定
                            updatedUserProfile.profileImageUrl = downloadUrlString
                            // 画像保存後にユーザープロフィールを保存
                            return mainService.saveUserProfile(user: updatedUserProfile, shouldUpdate: true)
                        }
                        .materialize()
                        .trackActivity(indicator)
                } else {
                    // ない場合は、空文字を設定し、デフォルト画像を適用
                    updatedUserProfile.profileImageUrl = ""
                    // ユーザープロフィールを保存
                    return mainService.saveUserProfile(user: updatedUserProfile, shouldUpdate: true)
                        .materialize()
                        .trackActivity(indicator)
                }
            }
            .share(replay: 1)
                        
        // ユーザープロフィール保存完了した場合、更新対象のユーザープロフィール情報を流す
        self.didSaveUserProfile = saveUserProfileResult
            .compactMap { $0.event.element }
            .map { _ in updatedUserProfile }
            .asDriver(onErrorJustReturn: nil)
        
        // ユーザープロフィール保存エラー
        let saveUserProfileError = saveUserProfileResult
            .compactMap { $0.event.error as? MyAppError }
        
        // 発生したエラーを一つに集約
        self.myAppError = Observable
            .merge(saveUserProfileError)
            .asDriver(onErrorJustReturn: .unknown)
    }
}
