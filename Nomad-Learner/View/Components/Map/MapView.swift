//
//  MapView.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/17.
//

import UIKit
import GoogleMaps

class MapView: GMSMapView {
        
    override init(options: GMSMapViewOptions) {
        let mapID = GMSMapID(identifier: "dd08da584c0df7f7")
        let camera = GMSCameraPosition(latitude: 47.0169, longitude: -122.336471, zoom: 12)
        options.mapID = mapID
        options.camera = camera
        super.init(options: options)
    }
    
    private func setupMap() {
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
