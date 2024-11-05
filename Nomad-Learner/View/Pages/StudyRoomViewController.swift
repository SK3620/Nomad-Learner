//
//  StudyRoomViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/13.
//

import Foundation
import UIKit
import SwiftUI
import RxSwift
import RxCocoa
import Firebase

class StudyRoomViewController: UIViewController {
    
    var locationInfo: LocationInfo!
    var userProfiles: [User] = []
    var latestLoadedDocDate: Timestamp?
    var oldestDocument: QueryDocumentSnapshot?
    
    private var viewModel: StudyRoomViewModel!
    
    // 背景画像
    private let backgroundImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "grassland")
    }
    
    // 休憩中に表示する背景View
    private let breakTimeView: UIView = UIView().then {
        $0.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        $0.isHidden = true
        // 休憩コーヒーアイコン
        let imageView = UIImageView(image: UIImage(systemName: "cup.and.saucer"))
        imageView.tintColor = .white
        $0.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(250)
        }
    }
    
    private let studyRoomNavigationBar: StudyRoomNavigationBar = StudyRoomNavigationBar()
    
    // チャット欄
    private let chatCollectionView: ChatCollectionView = ChatCollectionView()
    
    // プロフィール欄
    private let profileCollectionView: ProfileCollectionView = ProfileCollectionView()
    
    // contentLabelが使用可能な最大横幅 lazyで再取得を防ぐ
    private lazy var contentLabelMaxWidth: CGFloat  = {
        return self.chatCollectionView.bounds.width * 0.6
    }()
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
        update()
    }
    
    private func setupUI() {
        // studyRoomNavigationBarのitemを押下可能にする
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .clear
                
        view.addSubview(backgroundImageView)
        view.addSubview(breakTimeView)
        view.addSubview(studyRoomNavigationBar)
        view.addSubview(chatCollectionView)
        view.addSubview(profileCollectionView)
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        breakTimeView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        studyRoomNavigationBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            $0.height.equalTo(44)
            $0.width.equalTo(view.screenWidth * 0.68)
        }
        
        chatCollectionView.snp.makeConstraints {
            $0.left.equalTo(studyRoomNavigationBar.snp.right)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        profileCollectionView.snp.makeConstraints {
            $0.top.equalTo(studyRoomNavigationBar.snp.bottom)
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            $0.right.equalTo(chatCollectionView.snp.left).inset(-UIConstants.Layout.smallPadding)
            $0.bottom.equalToSuperview()
        }
    }
    
    // UIを更新
    private func update() {
        studyRoomNavigationBar.update(fixedLocation: locationInfo.fixedLocation)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // profileCollectionViewのframe値確定後、itemSizeを更新
        profileCollectionView.updateItemSize(size: profileCollectionView.bounds.size)
    }
}

extension StudyRoomViewController: KRProgressHUDEnabled {
    private func bind() {
        
        let viewModel = StudyRoomViewModel(
            mainService: MainService.shared,
            locationInfo: locationInfo,
            initialLoadedUserProfiles: userProfiles,
            latestLoadedDocDate: latestLoadedDocDate,
            oldestDocument: oldestDocument
        )
        
        self.viewModel = viewModel
        
        // ViewModelへイベントを流す
        publishEvent(to: viewModel)
        
        viewModel.userProfiles.drive(profileCollectionView.rx.items(cellIdentifier: ProfileCollectionViewCell.identifier, cellType: ProfileCollectionViewCell.self)) { row, item, cell in
            cell.configure(with: item)
        }
        .disposed(by: disposeBag)
        
        viewModel.messages.drive(chatCollectionView.rx.items(cellIdentifier: ChatCollectionViewCell.identifier, cellType: ChatCollectionViewCell.self)) { [weak self]  row, item, cell in
            guard let self = self else { return }
            cell.configure(with: item, maxWidth: self.contentLabelMaxWidth)
        }
        .disposed(by: disposeBag)
        
        // タイマー表示
        viewModel.timerText
            .drive(updateTimer)
            .disposed(by: disposeBag)
        
        // 背景画像切り替え
        viewModel.backgroundImageUrl
            .drive(switchBackgroundImage)
            .disposed(by: disposeBag)
        
        // profileCollectionViewCellタップ検知
        profileCollectionView.rx.itemSelected.asDriver()
            .withLatestFrom(viewModel.userProfiles) { indexPath, userProfiles in
                return (indexPath, userProfiles)
            }
            .drive(onNext: { [weak self] (indexPath, userProfiles) in
                guard let self = self else { return }
                viewModel.tappedProfile(at: indexPath)
                // ProfileVC（プロフィール画面）へ遷移
                Router.showProfile(vc: self, with: userProfiles[indexPath.row])
            })
            .disposed(by: disposeBag)
        
        // 追加データ取得（ページネーション）
        profileCollectionView.rx.contentOffset.asDriver()
            .map { _ in self.shouldRequestNextPage() }
            .distinctUntilChanged() // 無駄なリクエストの発生を防止
            .filter { $0 }
            .drive(onNext: { _ in viewModel.fetchMoreUserProfiles() })
            .disposed(by: disposeBag)
        
        // ローディングインジケーター
        viewModel.isLoading
            .drive(self.rx.showProgress)
            .disposed(by: disposeBag)
        
        // 画面レイアウト切り替えイベント購読
        viewModel.roomLayout
            .drive(updateRoomLayoutBinder)
            .disposed(by: disposeBag)
        
        // UIMenuActionイベントを購読
        viewModel.menuAction
            .compactMap { $0 } // nilを排除
            .drive(handleMenuAction)
            .disposed(by: disposeBag)
        
        // エラー
        viewModel.myAppError
            .map { AlertActionType.error($0) }
            .drive(self.rx.showAlert)
            .disposed(by: disposeBag)
    }
    
    // 追加データを読み込むべきか否か
    private func shouldRequestNextPage() -> Bool {
        return profileCollectionView.contentSize.height > 0 &&
            profileCollectionView.isNearBottomEdge()
    }
    
    // 各イベントをViewModelへ流す
    private func publishEvent(to viewModel: StudyRoomViewModel) {
        // 画面レイアウト切り替えイベントを流す
        studyRoomNavigationBar.switchLayoutButton.rx.tap.asDriver()
            .drive(onNext: { _ in viewModel.switchRoomLayout() })
            .disposed(by: disposeBag)
        
        // 押下されたMenuActionイベントを流す
        studyRoomNavigationBar.menuActionHandler = { action in
            viewModel.handleMenuAction(action: action)
        }
    }
}

// MARK: - StudyRoomViewController + Bindings
extension StudyRoomViewController: AlertEnabled {
    // タイマー表示
    private var updateTimer: Binder<String> {
        return Binder(self) { base, timerText in
            base.studyRoomNavigationBar.updateTimer(timerText: timerText)
        }
    }
    
    // 背景画像切り替え
    private var switchBackgroundImage: Binder<String> {
        return Binder(self) { base, imageUrl in
            UIView.animate(withDuration: 1.0, animations: {
                // 背景画像をフェードアウトさせる（透明にする）
                self.backgroundImageView.alpha = 0.0

            }) { _ in
                // フェードアウトが完了したら、新しい画像に更新
                self.backgroundImageView.setImage(with: imageUrl)
                UIView.animate(withDuration: 1.0) {
                    // 新しい画像をフェードインさせる（表示する）
                    self.backgroundImageView.alpha = 1.0
                }
            }
        }
    }
    
    // 画面レイアウト切り替え
    private var updateRoomLayoutBinder: Binder<StudyRoomViewModel.RoomLayout> {
        return Binder(self) { base, layout in
            let isProfileHidden: Bool
            let isChatHidden: Bool
            
            switch layout {
            case .displayAll:
                isProfileHidden = false
                isChatHidden = false
            case .hideProfile:
                isProfileHidden = true
                isChatHidden = false
            case .hideChat:
                isProfileHidden = false
                isChatHidden = true
            case .hideAll:
                isProfileHidden = true
                isChatHidden = true
            }
            // UIの更新を一箇所で行う
            base.profileCollectionView.isHidden = isProfileHidden
            base.chatCollectionView.isHidden = isChatHidden
        }
    }
    
    // UIMenuAction（休憩or勉強再開 コミュニティ 退出）
    private var handleMenuAction: Binder<StudyRoomViewModel.MenuAction> {
        return Binder(self) { base, action in
            switch action {
            case .breakTime, .restart:
                let isBreakTime = action == .breakTime
                base.breakTimeView.isHidden = !isBreakTime
                base.studyRoomNavigationBar.switchBreakOrRestartAction(action)
            case .community:
                print("Coming Soon")
            case .exitRoom:
                let alertActionType: AlertActionType = .exitRoom(
                    onConfirm: {
                        base.viewModel.saveStudyProgress(countedStudyTime: <#T##Int#>) {
                            Router.backToMapVC(vc: base) // MapVC（マップ画面）に戻る
                        }
                    }
                )
                Driver.just(alertActionType)
                    .drive(base.rx.showAlert)
                    .disposed(by: base.disposeBag)
            }
        }
    }
}

extension StudyRoomViewController {
    
    // 自動的に回転を許可しない
    override var shouldAutorotate: Bool {
        return false
    }
    
    // 回転の向き
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
}
