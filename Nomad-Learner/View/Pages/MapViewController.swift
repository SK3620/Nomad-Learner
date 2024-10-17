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
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController {
    
    private lazy var navigationBoxBar: NavigationBoxBar = NavigationBoxBar()
    
    private lazy var locationDetailView: LocationDetailView = LocationDetailView()
    
    // マップ
    private var mapView: MapView!
    
    // タブバー
    private lazy var mapTabBar: MapTabBar = MapTabBar()
    
    private let disposeBag = DisposeBag()
    
    // 認証画面へ戻るボタン
    private lazy var backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: nil, action: nil).then {
        $0.tintColor = .lightGray
    }
    // プロフィール画面遷移ボタン
    private lazy var profileBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: nil, action: nil).then {
        $0.tintColor = ColorCodes.primaryPurple.color()
    }
    
    // お財布アイコンと所持金ラベルのスタックビュー
    private lazy var walletStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.walletImageView, self.balanceLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    // 現在の所持金
    private let balanceLabel: UILabel = UILabel().then {
        $0.text = "100000"
        $0.font = .systemFont(ofSize: UIConstants.TextSize.semiSuperLarge, weight: .heavy)
        $0.textColor = .black
    }
    
    // お財布アイコン
    private let walletImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "wallet")
        $0.snp.makeConstraints { $0.size.equalTo(26) }
    }
    
    // ProfileVC（プロフィール画面）へ遷移
    private var toProfileVC: Void {
        Router.showProfile(vc: self)
    }
    
    // DepartVC（出発画面）へ遷移
    private var toDepartVC: Void {
        Router.showDepartVC(vc: self)
    }
    
    // AuthVC（認証画面）へ遷移
    private var backToAuthVC: Void {
        Router.dismissModal(vc: self)
    }
    
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
        
        // マップのセットアップ
        let options = GMSMapViewOptions()
        self.mapView = MapView(options: options)
        
        // ナビゲーションバーボタンアイテムの設定
        navigationItem.leftBarButtonItem = backBarButtonItem
        navigationItem.rightBarButtonItem = profileBarButtonItem
        navigationItem.titleView = walletStackView
        
        view.addSubview(mapView)
        view.addSubview(navigationBoxBar)
        view.addSubview(locationDetailView)
        view.addSubview(mapTabBar)
        
        navigationBoxBar.snp.makeConstraints {
            $0.width.top.equalToSuperview()
            $0.height.equalTo(180)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(navigationBoxBar.snp.bottom).inset(UIConstants.Layout.semiMediumPadding)
            $0.right.left.bottom.equalToSuperview()
        }
                
        locationDetailView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            $0.top.equalToSuperview().inset(NavigationHeightProvidable.totalTopBarHeight(navigationController: navigationController))
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
        
        // AuthVC（認証画面）へ遷移
        backBarButtonItem.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.backToAuthVC
            }
            .disposed(by: disposeBag)
        
        // ProfileVC（プロフィール画面）へ遷移
        profileBarButtonItem.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.toProfileVC
            }
            .disposed(by: disposeBag)
        
        // DepartVC（出発画面）へ遷移
        mapTabBar.airplaneItem.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.toDepartVC
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

extension MapViewController {
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

struct ViewControllerPreview: PreviewProvider {
    struct Wrapper: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            NavigationControllerForMapVC(rootViewController: MapViewController())
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
    static var previews: some View {
        Wrapper()
    }
}
