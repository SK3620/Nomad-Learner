//
//  APIKeys.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/09/25.
//

import Foundation

class APIKeys {
    
    // MARK: - GoogleMapAPIKey
    // 開発環境用 GoogleMapAPIKey
    private let googleMapAPIKeyDev: String = "AIzaSyAMDKRHPz7kupeR3GbukfzFoR5Wam8oF6c"
    // 本番環境用 GoogleMapAPIKey
    private let googleMapAPIKeyRelease = "AIzaSyApHuYXWKIns5dCgIe54LQ9IcEeaFgaqL8"
    
    public var googleMapAPIKey: String {
        #if DEVELOP // 開発環境
        return googleMapAPIKeyDev
        #else // 本番環境
        return googleMapAPIKeyRelease
        #endif
    }
}
