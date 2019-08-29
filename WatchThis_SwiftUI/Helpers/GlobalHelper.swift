//
//  GlobalVariables.swift
//  WatchThis
//
//  Created by Damonique Thomas on 8/18/18.
//  Copyright © 2018 Damonique Thomas. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FBSDKLoginKit

var userRef: DocumentReference? = nil
var favoriteShowRef: CollectionReference? = nil
var db:Firestore?
var user:User?
var favoriteShows = [Int]()
var recentSearched = [String]()

let imageCache = NSCache<NSString, UIImage>()
var configuration = Configuration()

// Firestore Document Names
struct FirestoreDocs {
    static let users = "users"
    static let favoriteTV = "favoriteTVShowIds"
}

func setUpFirestoreRefs() {
    if let userId = Auth.auth().currentUser?.uid {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if error != nil {
                // Process error
                print("Error: \(String(describing: error))")
            } else {
                guard let data: [String:AnyObject] = result  as? [String:AnyObject] else {
                    print("Can't pull data from JSON")
                    return
                }
                user = User(dictionary: data)
                db?.collection(FirestoreDocs.users).document(userId).setData(["name": user?.name ?? ""], merge: true)
            }
        })
        db?.collection(FirestoreDocs.users).document(userId).setData(["name": user?.name ?? ""], merge: true)
        userRef = db?.collection(FirestoreDocs.users).document(userId)
        userRef?.addSnapshotListener({ documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            if let favorites = data[FirestoreDocs.favoriteTV] as? [Int] {
                favoriteShows = favorites
            }
        })
    }
}

func getFavoriteTvIds(completionHandler: @escaping (_ result: [Int]) -> Void){
    userRef?.getDocument(completion: { (document, error) in
        if let ids = document?[FirestoreDocs.favoriteTV] as? [Int] {
            var sortedId = ids
            sortedId.sort {
                return $0 < $1
            }
            completionHandler(sortedId)
        }
    })
}

func getRecentSearches() -> [String] {
    return UserDefaults.standard.object(forKey: "RecentSearches") as? [String] ?? [String]()
}
