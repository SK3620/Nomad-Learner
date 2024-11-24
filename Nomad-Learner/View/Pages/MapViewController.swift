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
    private var locationsInfo: [LocationInfo] = []
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
    
    private let disposeBag = DisposeBag()
    
    // 認証画面へ戻るボタン
    private let backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: nil, action: nil).then {
        $0.tintColor = .lightGray
    }
    // リローディングボタン
    private let reloadButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.circlepath"), style: .plain, target: nil, action: nil).then {
        $0.tintColor = ColorCodes.primaryPurple.color()
    }
    // プロフィール画面遷移ボタン
    private let profileBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: nil, action: nil).then {
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
    private let currentCoinLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 24)
        $0.textColor = .black
        $0.text = "0"
    }
    
    // お財布アイコン
    private let walletImageView = UIImageView().then {
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
        mapView = MapView(options: options)
        mapView.delegate = self
        
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
            $0.top.equalTo(navigationBoxBar.snp.bottom).inset(24)
            $0.right.left.bottom.equalToSuperview()
        }
        
        locationDetailView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(NavigationHeightProvidable.totalTopBarHeight(navigationController: navigationController))
            $0.height.equalTo(195)
        }
        
        mapTabBar.snp.makeConstraints {
            $0.height.equalTo(70)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
                
        moveToCurrentLocationButton.snp.makeConstraints {
            $0.right.equalTo(mapTabBar)
            $0.centerY.equalTo(mapTabBar.snp.top)
            $0.size.equalTo(44)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // StudyRoomVC（勉強部屋画面）から戻ってきた時、ロケーション情報再取得
        if fromScreen == .studyRoomVC {
            viewModel.locationsAndUserInfo
                .map { ($0, DataHandlingType.fetchWithRewardAlert) }
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
        
        // 現在地ピン
        mapView.currentLocationPinButton.rx.tap
            .bind(to: displayCurrentLocationInfoWindow)
            .disposed(by: disposeBag)
        
        // 各ロケーション情報初回取得
        viewModel.locationsAndUserInfo
            .map { ($0, DataHandlingType.initialFetch) }
            .drive(handleLocationsInfo)
            .disposed(by: disposeBag)
        
        // 各ロケーション情報をリアルタイムリッスンで取得
        viewModel.monitoredLocationsAndUserInfo
            .map { ($0, DataHandlingType.listenerTriggered) }
            .drive(handleLocationsInfo)
            .disposed(by: disposeBag)
        
        // リロードボタンで各ロケーション情報を再取得
        reloadButtonItem.rx.tap.asDriver()
            .flatMap { [weak self] _ in
                guard let self = self else { return .empty() }
                return self.viewModel.locationsAndUserInfo
            }
            .map { ($0, DataHandlingType.manualReload) }
            .drive(handleLocationsInfo)
            .disposed(by: disposeBag)
        
        // 更新保留中の勉強記録データ取得
        viewModel.pendingUpdateData
            .filter { $0.pendingUpdateData != nil } // データがなければ処理中断
            .map { (($0.pendingUpdateData!, $0.saveRetryError)) }
            .drive(showSavePendingUpdateDataAlert)
            .disposed(by: disposeBag)
        
        // 更新保留中の勉強記録データ更新完了後、ロケーション情報再取得
        viewModel.isPendingUpdateDataHandlingCompleted
            .filter { $0 }
            .flatMap { [weak self] _ in
                guard let self = self else { return .empty() }
                return self.viewModel.locationsAndUserInfo
            }
            .map { ($0, DataHandlingType.fetchWithRewardAlert) }
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
                        base.mapView.clearPolyline() // ポリラインを削除
                        Router.showDepartVC(vc: base, locationInfo: locationInfo) // DepartVC（出発準備画面）へ遷移
                    },
                    ticketInfo: locationInfo.ticketInfo
                )
                base.rx.showAlert.onNext(alertActionType)
            } else {
                base.mapView.clearPolyline() // ポリラインを削除
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
    private var handleLocationsInfo: Binder<(([LocationInfo], User), DataHandlingType)> {
        return Binder(self) { base, tuple in
            let ((locationsInfo, userProfile), dataHandlingType) = tuple
            
            // プロパティ更新
            base.locationsInfo = locationsInfo
            base.userProfile = userProfile
            
            // マップの初期化
            base.resetMapView(with: locationsInfo, userProfile: userProfile)
            
            // データ取得に伴い、報酬コイン獲得アラートの表示を行う場合
            if dataHandlingType == .fetchWithRewardAlert {
                base.showRewardCoinProgressHUD()
            }
            
            // リスナー以外のデータ取得の場合
            if dataHandlingType != .listenerTriggered {
                base.moveCameraAndUpdateUIOnCurrentLocation()
            }
        }
    }
    // 現在地のInfoWindow表示
    private var displayCurrentLocationInfoWindow: Binder<Void> {
        return Binder(self) { base, _ in
            guard let currentCoordinate = base.mapView.currentCoordinate else { return }
            let marker = GMSMarker(position: currentCoordinate)
            marker.userData = base.locationsInfo.getCurrentLocationInfo(with: base.userProfile.currentLocationId)
            base.markerTapped(marker: marker)
            base.moveToCurrentLocation.onNext(())
        }
    }
    // 現在地までcamera移動
    private var moveToCurrentLocation: Binder<Void> {
        return Binder(self) { base, _ in
            guard let currentCoordinate = base.mapView.currentCoordinate else { return }
            let currentPosition = GMSCameraPosition(target: currentCoordinate, zoom: base.mapView.currentZoom)
            base.mapView.animate(to: currentPosition)
        }
    }
    // 更新保留中の勉強記録データの保存を行うか否か アラート表示
    private var showSavePendingUpdateDataAlert: Binder<(PendingUpdateData, saveRetryError: MyAppError?)> {
        return Binder(self) { base, tuple in
            let (pendingUpdateData, saveRetryError) = tuple
            let alertActionType = AlertActionType.savePendingUpdateData(
                saveRetryError: saveRetryError ?? nil,
                onConfirm: {
                    // 保存処理
                    base.viewModel.handlePendingUpdateData(pendingUpdateData: pendingUpdateData)
                },
                onCancel: {
                    // 削除処理
                    base.viewModel.handlePendingUpdateData(pendingUpdateData: pendingUpdateData, shouldSave: false)
                }
            )
            base.rx.showAlert.onNext(alertActionType)
        }
    }
}

extension MapViewController {
    // マップの初期化
    private func resetMapView(with locationsInfo: [LocationInfo], userProfile: User) {
        // マーカーを削除してリセット
        mapView.clear()
        
        // 現在地の座標を保持
        mapView.currentCoordinate = locationsInfo.getCurrentCoordinate(with: userProfile.currentLocationId)
        
        // 取得したロケーションをマーカーとして配置
        addMarkersForLocations()
        
        // UIを更新
        updateUI()
    }
    // カメラ移動＆現在地上のUIを生成
    private func moveCameraAndUpdateUIOnCurrentLocation() {
        // 現在地までカメラを移動
        moveToCurrentLocation.onNext(())
        
        // 既存InfoWindowを非表示
        mapView.removeInfoWindow()
        
        // 遅延させてUIを調整
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // 現在地ピンの位置を更新
            self.mapView.updateCurrentLocationPin()
            
            // 現在地のInfoWindow表示
            self.displayCurrentLocationInfoWindow.onNext(())
        }
    }
    // 現在地のロケーション情報を取得し、UIを更新
    private func updateUI() {
        let currentLocationId = userProfile.currentLocationId
        locationInfo = locationsInfo.getCurrentLocationInfo(with: currentLocationId)
        locationDetailView.update(ticketInfo: locationInfo!.ticketInfo, locationStatus: locationInfo!.locationStatus)
        currentCoinLabel.text = userProfile.currentCoin.toString
    }
    
    // 取得したロケーションをマーカーとしてマップ上に配置
    private func addMarkersForLocations() {
        mapView.clear() // 一度リセット
        mapView.addMarkersForLocations(locationsInfo: locationsInfo)
    }
    
    // 報酬コイン獲得ProgressHUDを表示
    private func showRewardCoinProgressHUD() {
        guard let rewardCoinProgressHUDInfo = locationsInfo.createRewardCoinProgressHUDInfo(with: userProfile) else { return }
        // ProgressHUD表示
        self.rx.showMessage.onNext(.getRewardCoin(info: rewardCoinProgressHUDInfo))
    }
    
    // マーカータップ時の処理
    private func markerTapped(marker: GMSMarker) {
        // プロパティを更新
        self.mapView.tappedMarker = marker
        
        // マーカーの関連情報を取得
        guard let locationInfo = marker.userData as? LocationInfo else { return }
        self.locationInfo = locationInfo
        
        // LocationDetailViewのUIを更新
        locationDetailView.update(ticketInfo: locationInfo.ticketInfo, locationStatus: locationInfo.locationStatus)
        
        // マーカーが初期位置なら出発ボタンを無効にする
        mapTabBar.airplaneItem.isEnabled = !locationInfo.locationStatus.isInitialLocation
        
        // InfoWindowを生成・表示
        self.mapView.addInfoWindow(locationInfo: locationInfo)
        
        // 現在位置の場合はポリラインを削除 それ以外の場合はポリラインを描画
        locationInfo.locationStatus.isMyCurrentLocation
        ? self.mapView.clearPolyline()
        : self.mapView.drawPolyline(from: self.mapView.currentCoordinate, to: marker.position)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    // マーカータップ時
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        markerTapped(marker: marker)
        return false
    }
    
    // 地図がズームイン/ズームアウトされた時に呼び出す
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        // ズームレベルが変更されてもサイズを一定に保つ
        self.mapView.updateCircleSizesOnZoom()
        // 現在地ピンの位置を更新
        self.mapView.updateCurrentLocationPin()
        // InfoWindowの位置を更新
        if self.mapView.infoWindow != nil { self.mapView.updateInfoWindowPosition() }
    }
    
    // マーカー以外タップ時
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        // UIを更新
        locationDetailView.update(ticketInfo: TicketInfo(), locationStatus: LocationStatus())
        // ポリライン削除
        self.mapView.clearPolyline()
        // 現在地ピンの位置を更新
        self.mapView.updateCurrentLocationPin()
        // InfoWindowを非表示
        self.mapView.removeInfoWindow()
        // 出発ボタン無効化
        mapTabBar.airplaneItem.isEnabled = false
    }
    
    // カメラが移動完了したときにズーム値を更新
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.mapView.currentZoom = position.zoom
        // 現在地ピンの位置を更新
        self.mapView.updateCurrentLocationPin()
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
