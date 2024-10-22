//
//  RealmServiceProtocol.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/21.
//

import Foundation
import Realm
import Firebase
import RxSwift
import RealmSwift

protocol RealmServiceProtocol {
    // Firebaseから取得したロケーション情報をRealmに保存
    func saveFixedLocations(_ locations: [FixedLocation]) -> Void
    // Realmからロケーション情報を取得
    func fetchFixedLocations() -> Observable<[FixedLocation]>
    // Realmからロケーション情報を削除
    func deleteFixedLocations() -> Void
}

final class RealmService: RealmServiceProtocol {
    
    public static let shared = RealmService()
    
    private let realm = try! Realm()

    private init() {}
    
    func saveFixedLocations(_ locations: [FixedLocation]) {
        try! realm.write {
            realm.add(locations) // 新しいデータを保存
        }
    }
    
    func fetchFixedLocations() -> Observable<[FixedLocation]> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            let realmLocations =  self.realm.objects(FixedLocation.self)
            let locations = Array(realmLocations)  // Realmのオブジェクトを配列に変換
            
            // データを流す
            observer.onNext(locations)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func deleteFixedLocations() {
        try! realm.write {
            realm.delete(realm.objects(FixedLocation.self)) // 一旦全てのデータを削除
        }
    }
}


