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
    
    // location
//    private var locations: [Location] = []
    
    override init(options: GMSMapViewOptions) {
        // セットアップ
        options.mapID = googleMapID
        options.camera = initialCamera
        super.init(options: options)
    }
    
    // 場所にマーカーを立てる
    func addMarkersForLocations(fixedLocations: [FixedLocation]) -> [GMSMarker] {
        // 登録したlocation全て取得
//        self.locations = Location.all
        // locationのマーカーを格納
        var markerArray: [GMSMarker] = []
        
        for location in fixedLocations {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let markerIconView = MarkerIconView(frame: CGRect(origin: .zero, size: CGSize(width: 45, height: 33) ))
            marker.iconView = markerIconView
            marker.userData = location
            markerArray.append(marker)
        }
        
        return markerArray
    }
    
    // ランダムなUIColorを生成する関数
    private func generateRandomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue = CGFloat(arc4random_uniform(256)) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
