//
//  FirebaseConfig.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/10/22.
//

import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage

struct FirebaseConfig {
    // MARK: - Firebase Realtime Database
    private let realtimeDb: DatabaseReference
    
    // MARK: - Stprage
    private let storage: StorageReference
    
    // MARK: - Firestore
    private let storeDb: Firestore
    
    // MARK: - Singleton instance
    public static let shared = FirebaseConfig()
    
    // MARK: - Paths
    struct Paths {
        static let locations = "locations"
        static let profileImages = "profileImages"
        static let users = "users"
        static let visitedLocations = "visitedLocations"
    }
    
    // MARK: - Initializer
    private init() {
        self.realtimeDb = Database.database().reference()
        self.storage = Storage.storage().reference()
        self.storeDb = Firestore.firestore()
    }
    
    // MARK: - Methods for accessing paths
    // Realtime Databaseのlocationsコレクションへの参照
    func locationsReference() -> DatabaseReference {
        return realtimeDb.child(Paths.locations)
    }
    
    // StorageのprofileImagesコレクションへの参照
    func profileImagesReference(with userId: String) -> StorageReference {
        return storage.child(Paths.profileImages).child("\(userId).jpg")
    }
    
    // Firestoreのusersコレクションへの参照
    func usersCollectionReference() -> CollectionReference {
        return storeDb.collection(Paths.users)
    }
    
    // FirestoreのvisitedLocationsコレクションへの参照
    func visitedCollectionReference(with userId: String) -> CollectionReference {
        return usersCollectionReference().document(userId).collection(Paths.visitedLocations)
    }
}
