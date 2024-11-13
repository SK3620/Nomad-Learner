//
//  MapView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/17.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils

class MapView: GMSMapView {
    
    // GoogleMap ID
    private let googleMapID = GMSMapID(identifier: GoogleMapID.googleMapID)
    // GMSMapViewOptions
    private var options: GMSMapViewOptions?
    // 現在のcameraのzoom値を保持
    var currentZoom: Float = 1.0
    // 現在地の座標
    var currentCoordinate: CLLocationCoordinate2D = .init()
    
    // ポリライン
    var polyline: GMSPolyline?
    // 目的地に描画される円
    var endCircle: GMSCircle?
    
    // 現在地ピン
    private let currentLocationPinImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "CurrentLocationPin")
        $0.tintColor = .blue
        $0.snp.makeConstraints { $0.size.equalTo(22) }
    }
    
    override init(options: GMSMapViewOptions) {
        // セットアップ
        options.mapID = googleMapID
        options.camera = GMSCameraPosition(target: .init(), zoom: 1.0)
        super.init(options: options)
        
        addSubview(currentLocationPinImageView)
    }
}

extension MapView {
    
    // 現在地ピンの位置を更新
    func updateCurrentLocationPin() {
        // 現在の地図上の位置を画面座標に変換
        let point = projection.point(for: currentCoordinate)
        // UIImageViewの中心を画面座標に合わせる
        currentLocationPinImageView.center = point
    }
    
    // マップの各ロケーションにマーカーを立てる
    func addMarkersForLocations(locationsInfo: LocationsInfo) {
        // 固定ロケーション取得
        let fixedLocations = locationsInfo.fixedLocations
        
        // 各固定ロケーションに対してマーカーを作成
        for fixedLocation in fixedLocations {
            // 固定ロケーションのIDを取得
            let fixedLocationId = fixedLocation.locationId
            // ロケーション状態を取得
            let locationStatus = locationsInfo.locationsStatus.first(where: { $0.locationId == fixedLocationId})!
            
            // 新しいマーカーを作成
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: fixedLocation.latitude, longitude: fixedLocation.longitude)
            
            // マーカーのアイコンビューを作成
            let markerIconView = MarkerIconView(
                frame: CGRect(origin: .zero, size: CGSize(width: 26, height: 35)),
                locationStatus: locationStatus
            )
            marker.iconView = markerIconView
            marker.userData = fixedLocation // マーカーに関連するデータを保存
            
            marker.map = self
        }
    }
}

extension MapView {
    // ポリライン描画
    func drawPolyline(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) {
        // 既存のポリラインと円をクリア（既存の描画があれば削除するため）
        clearPolyline()
        
        // カメラのズームに応じた円の半径を計算
        let circleRadiusScale = 1 / self.projection.points(forMeters: 1, at: start)
        let circleRadius = 5.0 * circleRadiusScale // 円の半径を調整
        
        // 終了地点に円を描画
        endCircle = GMSCircle(position: end, radius: circleRadius)
        endCircle?.fillColor = .blue // 終了地点の円の色を青色で設定
        endCircle?.map = self
        
        // 始点と終点の座標を設定してポリラインのパスを作成
        let path = GMSMutablePath()
        path.add(start) // 始点を追加
        path.add(end)   // 終点を追加
        
        // ポリラインを作成し、上記で設定したパスを設定
        polyline = GMSPolyline(path: path)
        
        // ポリラインのスタイル設定
        polyline?.strokeColor = .blue // 線の色を青色で設定
        polyline?.strokeWidth = 2     // 線の太さを設定
        polyline?.map = self           // ポリラインをマップに表示
    }
    
    // ズームレベル変更時に円のサイズを更新
    func updateCircleSizesOnZoom() {
        // ズームレベルを考慮して円の半径を再計算
        guard let endCircle = endCircle else { return }
        let circleRadiusScale = 1 / self.projection.points(forMeters: 1, at: endCircle.position)
        let circleRadius = 5.0 * circleRadiusScale // 円の半径を調整
        // 円の半径を更新
        endCircle.radius = circleRadius
    }
    
    // ポリライン削除
    func clearPolyline() {
        polyline?.map = nil
        endCircle?.map = nil
    }
}
