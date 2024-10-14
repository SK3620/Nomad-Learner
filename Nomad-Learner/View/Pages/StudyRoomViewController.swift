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
    
    private let chatCollectionView: ChatCollectionView = ChatCollectionView()
    
    private let profileCollectionView: ProfileCollectionView = ProfileCollectionView()
        
    // MapVC（マップ画面）に戻る
    private var backToMapVC: Void {
        Router.dismissModal(vc: self)
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
            $0.right.equalTo(chatCollectionView.snp.left).inset(-UIConstants.Layout.standardPadding)
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
        
        viewModel.profiles.drive(profileCollectionView.rx.items(cellIdentifier: ProfileCollectionViewCell.identifier, cellType: ProfileCollectionViewCell.self)) { row, item, cell in
            cell.configure(with: item)
        }
        .disposed(by: disposeBag)
        
        viewModel.messages.drive(chatCollectionView.rx.items(cellIdentifier: ChatCollectionViewCell.identifier, cellType: ChatCollectionViewCell.self)) { [weak self]  row, item, cell in
            guard let self = self else { return }
            cell.configure(with: item, maxWidth: self.contentLabelMaxWidth)
        }
        .disposed(by: disposeBag)
    }
}

/*
 extension MapViewController {
     private func bind() {

         let viewModel = MapViewModel()
         let collectionView = locationDetailView.locationCategoryCollectionView
         
         // カテゴリーをセルに表示
         viewModel.categories
             .drive(collectionView.rx.items(cellIdentifier: LocationCategoryCollectionViewCell.identifier, cellType: LocationCategoryCollectionViewCell.self)) { row, item, cell in
                 // 選択されたセルかどうか
                 let isSelected = viewModel.selectedIndex.value?.row == row
                 cell.configure(with: item, isSelected: isSelected)
                 cell.bind(indexPath: IndexPath(row: row, section: 0), viewModel: viewModel)
             }
             .disposed(by: disposeBag)
         
         viewModel.selectedIndex
             .drive(onNext:  { indexPath in
                 collectionView.reloadData()
                 collectionView.scrollToCenter(indexPath: indexPath)
             })
             .disposed(by: disposeBag)
     }
 }
 */

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

