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
    // 更新保留中の勉強記録データ保存
    func savePendingUpdateData(pendingUpdateData: PendingUpdateData)
    // 更新保留中の勉強記録データ取得
    func fetchPendingUpdateData() -> Observable<PendingUpdateData?>
    // 更新保留中の勉強記録データ削除
    func deletePendingUpdateData() -> Void
}

final class RealmService: RealmServiceProtocol {
    
    public static let shared = RealmService()
    
    private let realm = try! Realm()
    
    private init() {}
    
    func savePendingUpdateData(pendingUpdateData: PendingUpdateData) {
        do {
            try realm.write {
                if let userId = FBAuth.currentUserId, let pendingUpdateDataToDelete =  self.realm.objects(PendingUpdateData.self).first(where: { $0.userId == userId }) {
                    realm.delete(pendingUpdateDataToDelete)
                } else {
                    print("更新保留中の勉強記録データが存在しません。")
                }
                realm.add(pendingUpdateData)
            }
        } catch {
            print("更新保留中のデータ保存失敗: \(error)")
        }
    }
    
    func fetchPendingUpdateData() -> Observable<PendingUpdateData?> {
        return Observable.create { [weak self] observer in
            if let self = self, let userId = FBAuth.currentUserId, let pendingUpdateData =  self.realm.objects(PendingUpdateData.self).first(where: { $0.userId == userId }) {
                observer.onNext(pendingUpdateData)
            } else {
                print("更新保留中の勉強記録データが存在しません。")
                observer.onNext(nil)
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func deletePendingUpdateData() -> Void {
        do {
            try realm.write {
                if let userId = FBAuth.currentUserId, let pendingUpdateData =  self.realm.objects(PendingUpdateData.self).first(where: { $0.userId == userId })  {
                    realm.delete(pendingUpdateData)
                } else {
                    print("更新保留中の勉強記録データが存在しません。")
                }
            }
        } catch {
            print("更新保留中の勉強記録データ保存失敗 エラー内容: \(error)")
        }
    }
}
