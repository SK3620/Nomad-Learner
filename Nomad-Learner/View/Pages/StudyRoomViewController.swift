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
    
    // グローバル用にアクセス可能な共有インスタンスを保持
    static var sharedInstance: StudyRoomViewController?
    
    // 背景画像
    private lazy var backgroundImageView = UIImageView().then {
        guard let initialImageUrlString = locationInfo.fixedLocation.imageUrls.last else { return }
        $0.setImage(with: initialImageUrlString)
    }
    
    // 休憩中に表示する背景View
    private let breakTimeView = UIView().then {
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
    private lazy var chatCollectionView = ChatCollectionView().then {
        $0.delegate = self
    }
    
    // プロフィール欄
    private let profileCollectionView: ProfileCollectionView = ProfileCollectionView()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
        update()
        
        StudyRoomViewController.sharedInstance = self
        
        // バックグラウンド移行時
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // profileCollectionViewのframe値確定後、itemSizeを更新
        profileCollectionView.updateItemSize(size: profileCollectionView.bounds.size)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // 自身から監視を解除
        NotificationCenter.default.removeObserver(self)
    }
}

extension StudyRoomViewController {
    private func setupUI() {
        // studyRoomNavigationBarのitemを押下可能にする
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .black
        
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
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(16)
            $0.height.equalTo(44)
            $0.width.equalToSuperview().multipliedBy(0.66)
        }
        
        chatCollectionView.snp.makeConstraints {
            $0.left.equalTo(studyRoomNavigationBar.snp.right)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        profileCollectionView.snp.makeConstraints {
            $0.top.equalTo(studyRoomNavigationBar.snp.bottom)
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left).inset(16)
            $0.right.equalTo(chatCollectionView.snp.left).inset(-8)
            $0.bottom.equalToSuperview()
        }
    }
    
    // UIを更新
    private func update() {
        studyRoomNavigationBar.update(fixedLocation: locationInfo.fixedLocation)
    }
    
    // バックグラウンドへの移行時の処理
    @objc func didEnterBackground() {
        // アプリをキルした場合でもローカルに勉強記録等を保存しておく
        viewModel.saveStudyProgress(shouldSaveLocallyOnKill: true)
    }
}

extension StudyRoomViewController: KRProgressHUDEnabled {
    private func bind() {
        let viewModel = StudyRoomViewModel(
            mainService: MainService.shared,
            realmService: RealmService.shared,
            locationInfo: locationInfo,
            initialLoadedUserProfiles: userProfiles,
            oldestDocument: oldestDocument
        )
        self.viewModel = viewModel
        
        // ViewModelへイベントを流す
        publishEvent(to: viewModel)
        
        // ユーザープロフィール
        viewModel.userProfiles.drive(profileCollectionView.rx.items(cellIdentifier: ProfileCollectionViewCell.identifier, cellType: ProfileCollectionViewCell.self)) { row, item, cell in
            cell.configure(with: item)
        }
        .disposed(by: disposeBag)
        
        // メッセージ
        viewModel.messages
            .drive(chatCollectionView.rx.items(cellIdentifier: ChatCollectionViewCell.identifier, cellType: ChatCollectionViewCell.self)) { row, item, cell in
                cell.configure(with: item)
        }
        .disposed(by: disposeBag)
        
        // 新しいメッセージが追加されたらスクロール
        viewModel.messages
            .delay(RxTimeInterval.seconds(1)) // 最新のcellが生成されるまで遅延させる
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let bottomOffset = CGPoint(
                    x: 0,
                    y: max(0, self.chatCollectionView.contentSize.height - self.chatCollectionView.bounds.height + self.chatCollectionView.contentInset.bottom)
                )
                self.chatCollectionView.setContentOffset(bottomOffset, animated: true)
            })
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
            UIView.animate(withDuration: 1.5, animations: {
                // 背景画像をフェードアウトさせる（透明にする）
                self.backgroundImageView.alpha = 0.0
            }) { _ in
                // フェードアウトが完了したら、新しい画像に更新
                self.backgroundImageView.setImage(with: imageUrl)
                UIView.animate(withDuration: 1.5) {
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
    
    // UIMenuAction（休憩or勉強再開, チケット確認画面, コミュニティ, 退出）
    private var handleMenuAction: Binder<StudyRoomViewModel.MenuAction> {
        return Binder(self) { base, action in
            switch action {
            case .breakTime, .restart:
                let isBreakTime = action == .breakTime
                base.breakTimeView.isHidden = !isBreakTime
                base.studyRoomNavigationBar.switchBreakOrRestartAction(action)
            case .confirmTicket:
                Router.showTicketConfirmVC(vc: base, locationInfo: base.locationInfo)
            case .community:
                base.rx.showMessage.onNext(.inDevelopment)
            case .exitRoom:
                let alertActionType: AlertActionType = .exitRoom(
                    onConfirm: {
                        base.viewModel.saveStudyProgress() {
                            Router.backToMapVC(vc: base) // MapVC（マップ画面）に戻る
                        }
                    }
                )
                base.rx.showAlert.onNext(alertActionType)
            }
        }
    }
}

extension StudyRoomViewController: /*UICollectionViewDataSource,*/ UICollectionViewDelegateFlowLayout {
    
    // 固定な横幅と動的な高さのセルサイズを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCollectionViewCell.identifier, for: indexPath) as! ChatCollectionViewCell

        let message = viewModel.messages.unwrappedValue[indexPath.row].massage
        
        let width = chatCollectionView.bounds.width - cell.edgesSpacing * 2
        let contentLabelHeight = message.height(width: width, font: UIFont.systemFont(ofSize: 14))
        
        let estimatedHeight =
        cell.edgesSpacing * 2 // 微調整
        + cell.spacing
        + cell.profileImageViewHeight
        + contentLabelHeight
        
        return CGSize(width: width, height: estimatedHeight)
    }
}

extension StudyRoomViewController {
    // アプリをキルした場合でもローカルに勉強記録等を保存しておく
    func applicationDidEnterBackground() {
        viewModel.saveStudyProgress(shouldSaveLocallyOnKill: true)
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
