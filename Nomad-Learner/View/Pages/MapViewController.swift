//
//  MapViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/04.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa

class MapViewController: UIViewController {
    
    private lazy var navigationBoxBar: NavigationBoxBar = NavigationBoxBar()
    
    private lazy var locationDetailView: LocationDetailView = LocationDetailView()
    
    private let disposeBag = DisposeBag()
    
    // 認証画面へ戻るボタン
    private lazy var backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: nil, action: nil).then {
        $0.tintColor = .lightGray
    }
    // プロフィール画面遷移ボタン
    private lazy var profileBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: nil, action: nil).then {
        $0.tintColor = .lightGray
    }
        
    // タブバー
    private lazy var mapTabBar: MapTabBar = MapTabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UIのセットアップ
        setupUI()
        // viewModelとのバインディング
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        // 子ビューのレイアウト完了後にcollectionViewのitemSizeを決定する
        let layout = locationDetailView.locationCategoryCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: locationDetailView.bounds.width / 4, height: locationDetailView.bounds.height / 2)
    }
    
    private func setupUI() {
        
        // ナビゲーションバーの設定
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        title = "NavigationBar"
        
        // ナビゲーションバーボタンアイテムの設定
        navigationItem.leftBarButtonItem = backBarButtonItem
        navigationItem.rightBarButtonItem = profileBarButtonItem
        
        locationDetailView.locationCategoryCollectionView.register(LocationCategoryCollectionViewCell.self, forCellWithReuseIdentifier: LocationCategoryCollectionViewCell.identifier)
        
        view.addSubview(navigationBoxBar)
        view.addSubview(locationDetailView)
        view.addSubview(mapTabBar)
        
        navigationBoxBar.snp.makeConstraints {
            $0.width.top.equalToSuperview()
            $0.height.equalTo(180)
        }
        
        locationDetailView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            $0.top.equalToSuperview().offset(NavigationHeightProvidable.totalTopBarHeight(navigationController: navigationController))
            $0.height.equalTo(180)
        }
        
        mapTabBar.snp.makeConstraints {
            $0.height.equalTo(UIConstants.TabBarHeight.height)
            $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            $0.bottom.equalToSuperview().inset(UIConstants.Layout.semiMediumPadding)
        }
    }
}

extension MapViewController {
    private func bind() {
        
        // 認証画面へ戻る
        backBarButtonItem.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                Router.dismissModal(vc: self)
            }
            .disposed(by: disposeBag)
        
        // プロフィール画面へ遷移
        profileBarButtonItem.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                print("showProfileScreen")
            }
            .disposed(by: disposeBag)
        
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

struct ViewControllerPreview: PreviewProvider {
    struct Wrapper: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            UINavigationController(rootViewController: MapViewController())
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
    static var previews: some View {
        Wrapper()
    }
}
