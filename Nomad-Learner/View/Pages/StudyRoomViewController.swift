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

class StudyRoomViewController: UIViewController {
    
    private let backgroundImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "grassland")
    }
    
    private let studyRoomNavigationBar: StudyRoomNavigationBar = StudyRoomNavigationBar()
    
     let chatCollectionView: ChatCollectionView = ChatCollectionView()
    
    fileprivate let profileCollectionView: ProfileCollectionView = ProfileCollectionView()
        
    // MapVC（マップ画面）に戻る
    private var backToMapVC: Void {
        Router.backToMapVC(vc: self)
    }
    
    // ProfileVC（プロフィール画面）へ遷移
    private var toProfileVC: Void {
        Router.showProfile(vc: self)
    }
    
    // contentLabelが使用可能な最大横幅 lazyで再取得を防ぐ
    private lazy var contentLabelMaxWidth: CGFloat  = {
        return self.chatCollectionView.bounds.width * 0.6
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
    
    private func setupUI() {
        // studyRoomNavigationBarのitemを押下可能にする
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .clear
                
        view.addSubview(backgroundImageView)
        view.addSubview(studyRoomNavigationBar)
        view.addSubview(chatCollectionView)
        view.addSubview(profileCollectionView)
        
        backgroundImageView.snp.makeConstraints {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // profileCollectionViewのframe値確定後、itemSizeを更新
        profileCollectionView.updateItemSize(size: profileCollectionView.bounds.size)
    }
}

extension StudyRoomViewController {
    private func bind() {
        
        let viewModel = StudyRoomViewModel()
        
        // ViewModelへイベントを流す
        publishEvent(to: viewModel)
        
        viewModel.profiles.drive(profileCollectionView.rx.items(cellIdentifier: ProfileCollectionViewCell.identifier, cellType: ProfileCollectionViewCell.self)) { row, item, cell in
            cell.configure(with: item)
        }
        .disposed(by: disposeBag)
        
        viewModel.messages.drive(chatCollectionView.rx.items(cellIdentifier: ChatCollectionViewCell.identifier, cellType: ChatCollectionViewCell.self)) { [weak self]  row, item, cell in
            guard let self = self else { return }
            cell.configure(with: item, maxWidth: self.contentLabelMaxWidth)
        }
        .disposed(by: disposeBag)
        
        // profileCollectionViewCellタップ検知
        profileCollectionView.rx.itemSelected.asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                viewModel.tappedProfile(at: indexPath)
                // ProfileVC（プロフィール画面）へ遷移
                self.toProfileVC
            })
            .disposed(by: disposeBag)
        
        // 画面レイアウト切り替えイベント購読
        viewModel.roomLayout
            .drive(updateLayoutBinder)
            .disposed(by: disposeBag)
        
        // UIMenuActionイベントを購読
        viewModel.menuAction
            .compactMap { $0 } // nilを排除
            .drive(handleMenuAction)
            .disposed(by: disposeBag)
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

// MARK: -StudyRoomViewController + Bindings
extension StudyRoomViewController: AlertEnabled {
    // 画面レイアウト切り替え
    private var updateLayoutBinder: Binder<StudyRoomViewModel.RoomLayout> {
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
    
    // UIMenuAction（休憩 コミュニティ 退出）
    private var handleMenuAction: Binder<StudyRoomViewModel.MenuAction> {
        return Binder(self) { base, action in
            switch action {
            case .breakTime:
                print("休憩開始")
            case .community:
                print("コミュニティ閲覧")
            case .exitRoom:
                let alertActionType: AlertActionType = .exitRoom(
                    onConfirm: { base.backToMapVC }
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
        return .landscape
    }
}

struct ViewControllerPreview: PreviewProvider {
    struct Wrapper: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            NavigationControllerForStudyVC(rootViewController: StudyRoomViewController())
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
    static var previews: some View {
        Wrapper()
    }
}


