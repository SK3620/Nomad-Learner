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
    let alertActionType: Driver<AlertActionType>
    
    private let disposeBag = DisposeBag()
    
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
        // アラートの種類を流す
        let alertActionTypeRelay = BehaviorRelay<AlertActionType?>(value: nil)
        self.alertActionType = alertActionTypeRelay
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: .error(.unknown, onConfim: {}))
        
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
        
        // お試し利用用のユーザーか否か
        let isTrialUser = input.saveButtonTaps
            .asObservable()
            .map { _ in
                print("MyAppSettings.isTrialUser: \(MyAppSettings.isTrialUser)")
                return MyAppSettings.isTrialUser
            }
            .share(replay: 1)
        
        // お試し利用用のユーザーの場合、制限機能のアクセス不可アラートを表示
        isTrialUser
            .filter { $0 }
            .map { _ in AlertActionType.featureAccessDeniedInTrial() }
            .bind(to: alertActionTypeRelay)
            .disposed(by: disposeBag)
        
        // 編集したプロフィール内容の保存結果
        let saveUserProfileResult = isTrialUser
            .filter { !$0 }
            .withLatestFrom(userProfile)
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
                        .catch { error in // ストリームを終了させない
                            alertActionTypeRelay.accept(.error(error as! MyAppError))
                            return .empty()
                        }
                        .materialize()
                        .trackActivity(indicator)
                } else {
                    // ない場合は、空文字を設定し、デフォルト画像を適用
                    updatedUserProfile.profileImageUrl = ""
                    // ユーザープロフィールを保存
                    return mainService.saveUserProfile(user: updatedUserProfile, shouldUpdate: true)
                        .catch { error in // ストリームを終了させない
                            alertActionTypeRelay.accept(.error(error as! MyAppError))
                            return .empty()
                        }
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
    }
}
