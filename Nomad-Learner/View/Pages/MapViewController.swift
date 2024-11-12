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
import GoogleMapsUtils

class MapViewController: UIViewController, GMSMapViewDelegate {
    // 各ロケーションの情報
    private var locationsInfo: LocationsInfo = LocationsInfo()
    // タップされたマーカーのロケーション情報
    private var locationInfo: LocationInfo?
    // ユーザープロフィール情報
    var userProfile: User = User()
    // どの画面から戻ってきたかを記録するプロパティ
    var fromScreen: ScreenType?
    
    private lazy var navigationBoxBar: NavigationBoxBar = NavigationBoxBar()
    
    private lazy var locationDetailView: LocationDetailView = LocationDetailView()
    // タブバー
    private lazy var mapTabBar: MapTabBar = MapTabBar()
    
    // viewModel
    private var viewModel: MapViewModel!
    // マップ
    private var mapView: MapView!
    // マーカーのクラスタリング
    private var clusterManager: GMUClusterManager!
    
    private let disposeBag = DisposeBag()
    
    // 認証画面へ戻るボタン
    private lazy var backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: nil, action: nil).then {
        $0.tintColor = .lightGray
    }
    // リローディングボタン
    private lazy var reloadButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.circlepath"), style: .plain, target: nil, action: nil).then {
        $0.tintColor = ColorCodes.primaryPurple.color()
    }
    // プロフィール画面遷移ボタン
    private lazy var profileBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: nil, action: nil).then {
        $0.tintColor = ColorCodes.primaryPurple.color()
    }
    // お財布アイコンと所持金ラベルのスタックビュー
    private lazy var walletStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.walletImageView, self.currentCoinLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    // 現在の所持金
    private let currentCoinLabel: UILabel = UILabel().then {
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
    
    // 現在地までcameraを移動するボタン
    private let moveToCurrentLocationButton = UIButton().then {
        $0.backgroundColor = .white
        $0.applyShadow(color: .black, opacity: 0.6, offset: CGSize(width: 0.5, height: 4), radius: 5)
        $0.layer.cornerRadius = 44 / 2
        $0.setImage(UIImage(systemName: "dot.scope"), for: .normal)
        $0.imageView?.tintColor = ColorCodes.primaryPurple.color()
        $0.imageView?.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UIのセットアップ
        setupUI()
        // viewModelとのバインディング
        bind()
    }
    
    private func setupUI() {
        // マップを表示
        let options = GMSMapViewOptions()
        self.mapView = MapView(options: options)
        
        // ナビゲーションバーの設定
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // ナビゲーションバーボタンアイテムの設定
        navigationItem.leftBarButtonItems = [backBarButtonItem, reloadButtonItem]
        navigationItem.rightBarButtonItem = profileBarButtonItem
        navigationItem.titleView = walletStackView
        
        view.addSubview(mapView)
        view.addSubview(navigationBoxBar)
        view.addSubview(locationDetailView)
        view.addSubview(mapTabBar)
        view.addSubview(moveToCurrentLocationButton)
        
        navigationBoxBar.snp.makeConstraints {
            $0.width.top.equalToSuperview()
            $0.height.equalTo(180)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(navigationBoxBar.snp.bottom).inset(UIConstants.Layout.mediumPadding)
            $0.right.left.bottom.equalToSuperview()
        }
        
        locationDetailView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            $0.top.equalToSuperview().inset(NavigationHeightProvidable.totalTopBarHeight(navigationController: navigationController))
            $0.height.equalTo(195)
        }
        
        mapTabBar.snp.makeConstraints {
            $0.height.equalTo(UIConstants.TabBarHeight.height)
            $0.horizontalEdges.equalToSuperview().inset(UIConstants.Layout.standardPadding)
            $0.bottom.equalToSuperview().inset(UIConstants.Layout.semiMediumPadding)
        }
                
        moveToCurrentLocationButton.snp.makeConstraints {
            $0.right.equalTo(mapTabBar)
            $0.centerY.equalTo(mapTabBar.snp.top)
            $0.size.equalTo(44)
        }
    }
    
    // クラスターマネージャーのセットアップメソッド
    private func setupClusterManager() {
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        clusterManager.clearItems() // 既存のクラスターをリセット
        clusterManager.setMapDelegate(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // StudyRoomVC（勉強部屋画面）から戻ってきた時、データ再取得
        if fromScreen == .studyRoomVC {
            viewModel.locationsAndUserInfo
                .drive(handleLocationsInfo)
                .disposed(by: disposeBag)
        }
    }
    
    override func viewDidLayoutSubviews() {
        // 子ビューのレイアウト完了後にcollectionViewのitemSizeを決定する
        let layout = locationDetailView.locationCategoryCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: locationDetailView.bounds.width / 4, height: locationDetailView.bounds.height / 2)
    }
}

extension MapViewController: KRProgressHUDEnabled, AlertEnabled {
    private func bind() {
        // AuthVC（認証画面）へ遷移
        backBarButtonItem.rx.tap
            .bind(to: backToAuthVC)
            .disposed(by: disposeBag)
        
        // ProfileVC（プロフィール画面）へ遷移
        profileBarButtonItem.rx.tap
            .bind(to: toProfileVC)
            .disposed(by: disposeBag)
        
        // DepartVC（出発画面）への遷移制御
        mapTabBar.airplaneItem.rx.tap
            .bind(to: departVCAccessControl)
            .disposed(by: disposeBag)
        
        // 学習記録画面へ遷移（現在開発中の機能のため、ProgressHUDを表示）
        mapTabBar.reportItem.rx.tap
            .map { ProgressHUDMessage.inDevelopment }
            .bind(to: self.rx.showMessage)
            .disposed(by: disposeBag)
        
        self.viewModel = MapViewModel(
            mainService: MainService.shared,
            realmService: RealmService.shared
        )
        let collectionView = locationDetailView.locationCategoryCollectionView
        
        // カテゴリーをセルに表示
        viewModel.categories
            .drive(collectionView.rx.items(cellIdentifier: LocationCategoryCollectionViewCell.identifier, cellType: LocationCategoryCollectionViewCell.self)) { [weak self] row, item, cell in
                guard let self = self else { return }
                // 選択されたセルかどうか
                let isSelected = self.viewModel.selectedIndex.value?.row == row
                cell.configure(with: item, isSelected: isSelected)
                cell.bind(indexPath: IndexPath(row: row, section: 0), viewModel: self.viewModel)
            }
            .disposed(by: disposeBag)
        
        viewModel.selectedIndex
            .drive(onNext:  { indexPath in
                collectionView.reloadData()
                collectionView.scrollToCenter(indexPath: indexPath)
            })
            .disposed(by: disposeBag)
        
        // 現在地までcamera移動
        moveToCurrentLocationButton.rx.tap
            .bind(to: moveToCurrentLocation)
            .disposed(by: disposeBag)
        
        // 各ロケーション情報
        viewModel.locationsAndUserInfo
            .drive(handleLocationsInfo)
            .disposed(by: disposeBag)
        
        // リロードで各ロケーション情報を再取得
        reloadButtonItem.rx.tap.asDriver()
            .flatMap { [weak self] _ in
                guard let self = self else { return .empty() }
                return self.viewModel.locationsAndUserInfo
            }
            .drive(handleLocationsInfo)
            .disposed(by: disposeBag)
        
        // ローディングインジケーター
        viewModel.isLoading
            .drive(self.rx.showProgress)
            .disposed(by: disposeBag)
        
        // エラー
        viewModel.myAppError
            .map { AlertActionType.error($0) }
            .drive(self.rx.showAlert)
            .disposed(by: disposeBag)
    }
}

extension MapViewController {
    // ProfileVC（プロフィール画面）へ遷移
    private var toProfileVC: Binder<Void> {
        return Binder(self) { base, _ in Router.showProfile(vc: base, with: base.userProfile) }
    }
    // DepartVC（出発画面）へ遷移制御
    private var departVCAccessControl: Binder<Void> {
        return Binder(self) { base, _ in
            guard let locationInfo = base.locationInfo else { return }
            
            let isSufficientCoin = locationInfo.locationStatus.isSufficientCoin
            let hasntVisited = locationInfo.visitedLocation == nil
            
            if !isSufficientCoin {
                // 所持金が足りない場合、警告を表示
                base.rx.showMessage.onNext(.insufficientCoin)
                return
            }
            
            if hasntVisited {
                // 初回訪問の場合、アラートを表示して遷移
                let alertActionType = AlertActionType.willShowDepartVC(
                    onConfirm: { 
                        base.mapView.clearDashedLine() // ポリラインを削除
                        Router.showDepartVC(vc: base, locationInfo: locationInfo) // DepartVC（出発準備画面）へ遷移
                    },
                    ticketInfo: locationInfo.ticketInfo
                )
                base.rx.showAlert.onNext(alertActionType)
            } else {
                base.mapView.clearDashedLine() // ポリラインを削除
                // 既に訪問済みの場合、直接DepartVCへ遷移
                Router.showDepartVC(vc: base, locationInfo: locationInfo)
            }
        }
    }
    // AuthVC（認証画面）へ遷移
    private var backToAuthVC: Binder<Void> {
        return Binder(self) { base, _ in Router.dismissModal(vc: base) }
    }
    // 取得したロケーション情報とユーザー情報を制御
    private var handleLocationsInfo: Binder<(LocationsInfo, User)> {
        return Binder(self) { base, tuple in
            let (locationsInfo, userProfile) = tuple
            // プロパティ更新
            base.locationsInfo = locationsInfo
            base.userProfile = userProfile
            
            // 取得したロケーションをマーカーとしてマップ上に配置
            base.addMarkersForLocations()
            // UIを更新
            base.updateUI()
            // 報酬コイン獲得ProgressHUDを表示
            base.showRewardCoinProgressHUD()
            // 現在地までcamera移動
            base.moveToCurrentLocation.onNext(())
        }
    }
    // 現在地までcamera移動
    private var moveToCurrentLocation: Binder<Void> {
        return Binder(self) { base, _ in
            if let currentLocationInfo = base.locationsInfo.fixedLocations.first(where: { $0.locationId == base.userProfile.currentLocationId }) {
                let currentPosition = GMSCameraPosition(latitude: currentLocationInfo.latitude, longitude: currentLocationInfo.longitude, zoom: 1.0)
                base.mapView.animate(to: currentPosition)
            }
        }
    }
}

extension MapViewController {
    // 現在地のロケーション情報を取得し、UIを更新
    private func updateUI() {
        let currentLocationId = userProfile.currentLocationId
        let currentLocationInfo = locationsInfo.createLocationInfo(of: currentLocationId)
        locationInfo = currentLocationInfo
        locationDetailView.update(ticketInfo: currentLocationInfo.ticketInfo, locationStatus: currentLocationInfo.locationStatus)
        currentCoinLabel.text = userProfile.currentCoin.toString
    }
    
    // 取得したロケーションをマーカーとしてマップ上に配置
    private func addMarkersForLocations() {
        setupClusterManager()
        // ロケーションマーカーを追加し、クラスタリング
        clusterManager.add(mapView.addMarkersForLocations(locationsInfo: locationsInfo))
        clusterManager.cluster()
    }
    
    // 報酬コイン獲得ProgressHUDを表示
    private func showRewardCoinProgressHUD() {
        guard let rewardCoinProgressHUDInfo = locationsInfo.createRewardCoinProgressHUDInfo(userProfile: userProfile) else { return }
        // ProgressHUD表示
        self.rx.showMessage.onNext(.getRewardCoin(info: rewardCoinProgressHUDInfo))
    }
}

extension MapViewController: CLLocationManagerDelegate {
    // infoWindowを表示
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if let location = marker.userData as? FixedLocation {
            // width, heightは固定
            let window = MarkerInfoWindow(frame: CGRect.init(x: 0, y: 0, width: 250, height: 50))
            window.configure(location: location)
            return window
        }
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        // タップされたマーカーの情報を取得
        guard let tappedLocation = marker.userData as? FixedLocation else {
            return false
        }
        // locationInfo の更新
        locationInfo = locationsInfo.createLocationInfo(of: tappedLocation.locationId)
        // UI更新
        if let locationInfo = locationInfo {
            locationDetailView.update(ticketInfo: locationInfo.ticketInfo, locationStatus: locationInfo.locationStatus)
        }
        // 初期位置なら、出発できないように設定
        if let locationStatus = locationInfo?.locationStatus {
            mapTabBar.airplaneItem.isEnabled = !locationStatus.isInitialLocation
        }
        // 現在地以外のマーカーをタップした場合、ルートを描画
        if userProfile.currentLocationId != locationInfo?.fixedLocation.locationId {
            let currentCoordinate = locationsInfo.getCurrentCoordinate(currentLocationId: userProfile.currentLocationId)
            self.mapView.drawDashedLine(from: currentCoordinate, to: marker.position)
        }
        return false
    }
    
    // 地図がズームイン/ズームアウトされた時に呼び出す
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        // ズームレベルが変更されてもサイズを一定に保つ
        self.mapView.updateCircleSizesOnZoom()
    }
    
    // マーカー以外タップ時
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        (mapView as? MapView)?.clearDashedLine() // ポリライン削除
        // UIを更新
        locationDetailView.update(ticketInfo: TicketInfo(), locationStatus: LocationStatus())
        mapTabBar.airplaneItem.isEnabled = false // 出発ボタン無効化
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
