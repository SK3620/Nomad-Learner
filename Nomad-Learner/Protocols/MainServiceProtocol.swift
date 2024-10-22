//
//  MainServiceProtocol.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/21.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth
import FirebaseDatabase

protocol MainServiceProtocol {
    // Firebaseからロケーションデータ取得
    func fetchFixedLocations() -> Observable<[FixedLocation]>
    // Realmからデータを取得
//    func fetchLocationsFromRealm() -> Observable<[FixedLocation]>
}

final class MainService: MainServiceProtocol {
    
    public static let shared = MainService()
    
    private let databaseRef: DatabaseReference = Database.database().reference().child("locations")

    private init(){}
    
    // マップのマーカーに設定するロケーション情報取得
    func fetchFixedLocations() -> Observable<[FixedLocation]> {
        return Observable.create { observer in
            self.databaseRef.observe(.value) { snapshot in
                if !snapshot.exists() {
                    observer.onError(MyAppError.locationEmpty)
                }
                
                 var locations = [FixedLocation]()
                // Firebaseのスナップショットからデータを抽出し、FixedLocationに変換
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let locationData = childSnapshot.value as? [String: Any],
                       let location = FixedLocationParser.parse(childSnapshot.key, locationData)
                    {
                        locations.append(location)
                    }
                }
                observer.onNext(locations)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
