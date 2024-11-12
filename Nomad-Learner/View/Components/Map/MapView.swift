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
