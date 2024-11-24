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
    var currentCoordinate: CLLocationCoordinate2D?
    
    // タップされたマーカー
    var tappedMarker: GMSMarker?
    // タップされたマーカーの座標
    var tappedMarkerCoordinate: CLLocationCoordinate2D { tappedMarker!.position }
    
    // ポリライン
    var polyline: GMSPolyline?
    // 目的地に描画される円
    var endCircle: GMSCircle?
    
    // InfoWindow
    var infoWindow: MarkerInfoWindow?
    // IconView 高さ
    private let IconViewHeight: CGFloat = 35
    
    // 現在地ピン
    let currentLocationPinButton = UIButton().then {
        let image = UIImage(named: "CurrentLocationPin")
        $0.setImage(image, for: .normal)
        $0.frame = CGRect(origin: .zero, size: CGSize(width: 24, height: 24))
        $0.isHidden = true
    }
    
    override init(options: GMSMapViewOptions) {
        // セットアップ
        options.mapID = googleMapID
        options.camera = MyAppSettings.userInitialLocationCoordinateWithZoom
        super.init(options: options)
        
        addSubview(currentLocationPinButton)
    }
    
    func addInfoWindow(locationInfo: LocationInfo) {
        // 既存のInfoWindowを非表示
        removeInfoWindow()
        
        let frame = CGRect(origin: .zero, size: CGSize(width: 250, height: 50))
        infoWindow = MarkerInfoWindow(frame: frame, locationInfo: locationInfo)
        updateInfoWindowPosition()
        
        addSubview(infoWindow!)
    }
}

extension MapView {
    
    // 現在地ピンの位置を更新
    func updateCurrentLocationPin() {
        guard let currentCoordinate = currentCoordinate else {
            currentLocationPinButton.isHidden = true
            return
        }
        // 現在の地図上の位置を画面座標に変換
        let point = projection.point(for: currentCoordinate)
        // UIImageViewの中心を画面座標に合わせる
        currentLocationPinButton.center = point
        currentLocationPinButton.isHidden = false
    }
    
    // InfoWindowの位置を更新
    func updateInfoWindowPosition() {
        let markerPoint = projection.point(for: tappedMarkerCoordinate)
        let centerY = markerPoint.y - (IconViewHeight + infoWindow!.viewHeight / 2)
        let centerX = markerPoint.x
        let centerPoint = CGPoint(x: centerX, y: centerY)
        infoWindow?.center = centerPoint
    }
    
    // InfoWindowを非表示
    func removeInfoWindow() {
        infoWindow?.removeFromSuperview()
    }
    
    // マップの各ロケーションにマーカーを立てる
    func addMarkersForLocations(locationsInfo: [LocationInfo]) {
        // 各固定ロケーションに対してマーカーを作成
        for locationInfo in locationsInfo {
            // 新しいマーカーを作成
            let marker = GMSMarker(position: locationInfo.fixedLocation.coordinate)
            // マーカーのアイコンビューを作成
            let markerIconView = MarkerIconView(
                frame: CGRect(origin: .zero, size: CGSize(width: 26, height: IconViewHeight)),
                locationStatus: locationInfo.locationStatus
            )
            marker.iconView = markerIconView
            marker.userData = locationInfo // マーカーに関連するデータを保存
            
            marker.map = self
        }
    }
}

extension MapView {
    // ポリライン描画
    func drawPolyline(from start: CLLocationCoordinate2D?, to end: CLLocationCoordinate2D) {
        guard let start = start else { return }
        // 既存のポリラインと円をクリア（既存の描画があれば削除するため）
        clearPolyline()
        
        // カメラのズームに応じた円の半径を計算
        let circleRadiusScale = 1 / self.projection.points(forMeters: 1, at: start)
        let circleRadius = 7 * circleRadiusScale // 円の半径を調整
        
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
        let circleRadius = 7 * circleRadiusScale // 円の半径を調整
        // 円の半径を更新
        endCircle.radius = circleRadius
    }
    
    // ポリライン削除
    func clearPolyline() {
        polyline?.map = nil
        endCircle?.map = nil
    }
}
