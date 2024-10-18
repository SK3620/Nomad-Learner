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
    private let initialCamera = GMSCameraPosition(latitude: 47.0169, longitude: -122.336471, zoom: 12)
    
    // location
    private var locations: [Location] = []
    // locationのマーカー
    lazy var markerArray: [GMSMarker] = {
        return self.addMarkersForLocations()
    }()
        
    override init(options: GMSMapViewOptions) {
        // セットアップ
        options.mapID = googleMapID
        options.camera = initialCamera
        super.init(options: options)
    }
    
    // 場所にマーカーを立てる
    private func addMarkersForLocations() -> [GMSMarker] {
        // 登録したlocation全て取得
        self.locations = Location.all
        // locationのマーカーを格納
        var markerArray: [GMSMarker] = []
        
        for location in locations {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            marker.icon = GMSMarker.markerImage(with: generateRandomColor())
            marker.title = location.name
            marker.snippet = "\(location.region), \(location.country)"
            // marker.map = self
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
    
  
   
    /*
    private func setupMap() {
        // Set initial camera position to Sydney, Australia
        let sydney = CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093)
        let camera = GMSCameraPosition.camera(withTarget: sydney, zoom: 10)
        self.camera = camera
        
        // Create and add a marker at Sydney
        let marker = GMSMarker(position: sydney)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = self
    }
     */
}
