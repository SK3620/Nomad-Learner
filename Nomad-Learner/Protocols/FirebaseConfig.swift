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
        static let fixedLocations = "fixedLocations"
        static let profileImages = "profileImages"
        static let users = "users"
        static let visitedLocations = "visitedLocations"
        static let locations = "locations"
    }
    
    // MARK: - Initializer
    private init() {
        self.realtimeDb = Database.database().reference()
        self.storage = Storage.storage().reference()
        self.storeDb = Firestore.firestore()
    }
    
    // MARK: - Methods for accessing paths
    // Realtime Database fixedLocations
    func fixedLocationsReference() -> DatabaseReference {
        return realtimeDb.child(Paths.fixedLocations)
    }
    
    // Storage profileImages
    func profileImagesReference(with userId: String) -> StorageReference {
        return storage.child(Paths.profileImages).child("\(userId).jpg")
    }
    
    // users
    func usersCollectionReference() -> CollectionReference {
        return storeDb.collection(Paths.users)
    }
    
    // users/{userId}/visitedLocations
    func visitedCollectionReference(with userId: String) -> CollectionReference {
        return usersCollectionReference().document(userId).collection(Paths.visitedLocations)
    }
    
    // locations
    func locationsCollectionReference() -> CollectionReference {
        return storeDb.collection(Paths.locations)
    }
    
    // locations/{locationId}/users
    func usersInLocationsReference(with locationId: String) -> CollectionReference {
        return locationsCollectionReference().document(locationId).collection(Paths.users)
    }
}
