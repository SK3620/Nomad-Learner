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
    // 初期位置 縮小具合
    private let initialCamera = GMSCameraPosition(latitude: -33.857, longitude: 151.215, zoom: 1.0)
    // ロケーション情報
    private var locationsInfo: LocationsInfo = LocationsInfo()
    
    // 描画された円を保持
    var circles: [GMSCircle] = []
    
    override init(options: GMSMapViewOptions) {
        // セットアップ
        options.mapID = googleMapID
        options.camera = initialCamera
        super.init(options: options)
    }
    
    // マップの各ロケーションにマーカーを立てる
    func addMarkersForLocations(locationsInfo: LocationsInfo) -> [GMSMarker] {
        // 固定ロケーション取得
        let fixedLocations = locationsInfo.fixedLocations
        // マーカーを格納する配列
        var markerArray: [GMSMarker] = []
        
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
            let adjustedWidth: CGFloat = locationStatus.isMyCurrentLocation ? 57 : 45 // UIパーツがはみ出ないように幅調整
            let markerIconView = MarkerIconView(
                frame: CGRect(origin: .zero, size: CGSize(width: adjustedWidth, height: 33)),
                locationStatus: locationStatus
            )
            marker.iconView = markerIconView
            marker.userData = fixedLocation // マーカーに関連するデータを保存
            
            // 作成したマーカーを配列に追加
            markerArray.append(marker)
        }
        return markerArray  // 作成したマーカーの配列を返す
    }
}

extension MapView {
    // ダッシュラインを描画するメソッド
    func drawDashedLine(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) {
        // 既存の円を削除（もしあれば）
        clearDashedLine()
        
        // 2点間の距離を計算
        let startLocation = CLLocation(latitude: start.latitude, longitude: start.longitude)
        let endLocation = CLLocation(latitude: end.latitude, longitude: end.longitude)
        let distance = startLocation.distance(from: endLocation) // 距離(m単位)
        
        // ドット間の距離と円の半径
        let intervalDistance: CLLocationDistance = 500000 // 500kmごとに円
        let circleRadiusScale = 1 / self.projection.points(forMeters: 1, at: start)
        let circleRadius = 5.0 * circleRadiusScale // 円の半径を調整
        
        // 開始地点に円を描画
        let startCircle = GMSCircle(position: start, radius: circleRadius)
        startCircle.fillColor = .blue
        startCircle.map = self
        circles.append(startCircle)
        
        // 終了地点に円を描画
        let endCircle = GMSCircle(position: end, radius: circleRadius)
        endCircle.fillColor = .blue // 色を変えて区別
        endCircle.map = self
        circles.append(endCircle)
        
        // 2点間に均等な間隔で円を描画
        let totalCircles = Int(distance / intervalDistance) // 必要な円の数
        for i in 1..<totalCircles {
            let fraction = CGFloat(i) / CGFloat(totalCircles)
            
            // 線形補間で位置を計算
            let latitude = start.latitude + (end.latitude - start.latitude) * Double(fraction)
            let longitude = start.longitude + (end.longitude - start.longitude) * Double(fraction)
            
            // 円の位置
            let circlePosition = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            // 円を描画
            let circle = GMSCircle(position: circlePosition, radius: circleRadius)
            circle.fillColor = .blue
            circle.map = self
            
            // 円を配列に追加
            circles.append(circle)
        }
    }
    
    // ズームレベル変更時に円のサイズを更新
    func updateCircleSizesOnZoom() {
        for circle in circles {
            // ズームレベルを考慮して円の半径を再計算
            let circleRadiusScale = 1 / self.projection.points(forMeters: 1, at: circle.position)
            let circleRadius = 5.0 * circleRadiusScale // 円の半径を調整
            
            // 円の半径を更新
            circle.radius = circleRadius
        }
    }

    // ポリライン削除
    func clearDashedLine() {
        // すべての円を削除
        for circle in circles {
            circle.map = nil // マップから削除
        }
        // 配列をクリア
        circles.removeAll()
    }
}
