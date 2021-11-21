//
//  PublicPostManager.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/18.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

class PublicPostManager {
    
    static let shared = PublicPostManager()
    
    lazy var db = Firestore.firestore()
    
    let user = Auth.auth().currentUser
    
    let uid = Auth.auth().currentUser?.uid
    
    // create
    func createPublicPost(screenshotURL: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let uid = uid else { return }
        
        let docRef = db.collection(Collections.publicPost.rawValue)
        
        docRef.document().setData([
            
            "createdTime": Date().millisecondsSince1970,
            "uid": uid as Any,
            "postStatus": 1,
            "screenshotURL": screenshotURL
        ]) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("Success"))
            }
        }
    }
    
    // fetch all publicPost data
    func fetchAllPublicPostInfo(completion: @escaping (Result<[PublicPost], Error>) -> Void) {
        
        db.collection(Collections.publicPost.rawValue)
            .getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                var allPublicPosts = [PublicPost]()
                
                guard let querySnapshot = querySnapshot else { return }
                
                for document in querySnapshot.documents {
                    
                    do {
                        if let allpublicPost = try document.data(as: PublicPost.self, decoder: Firestore.Decoder()) {
                            allPublicPosts.append(allpublicPost)
                        }
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
                
                completion(.success(allPublicPosts))
            }
        }
    }
}
