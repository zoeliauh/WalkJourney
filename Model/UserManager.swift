//
//  UserManager.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/4.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

class UserManager {
    
    static let shartd = UserManager()
    
    lazy var db = Firestore.firestore()
    
    private init() {}
    
    let userID: String = {
        
        if let user = Auth.auth().currentUser {
            return user.uid
        } else {
            return "0"
        }
    }()
    
    let userDisplayName: String = {
        
        if let user = Auth.auth().currentUser,
           let userName = user.displayName {
            return userName
        } else {
            return "使用者"
        }
    }()
    
    // create
    func createUserInfo() {
        let user = User(userID: userID,
                        username: userDisplayName,
                        email: nil, userImageURL: nil,
                        providerID: nil, blockLists: nil,
                        friendLists: nil)
        
        let userRef = db.collection("User")
        
        searchUserisExist(userID: userID) { isExists in
            if !isExists {
                do {
                    
                    try userRef.document(user.userID).setData(from: user)
                    
                } catch {
                    
                    print("Fail to create user")
                }
            }
        }
    }
    
    func searchUserisExist(userID: String, isExists: @escaping (Bool) -> Void) {
        
        let userRef = db.collection("User")
        
        userRef.document(userID).getDocument { document, _ in
            if let document = document {
                
                if document.exists {
                    
                    isExists(true)
                    
                } else {
                    
                    isExists(false)
                }
                
            } else {
                
                isExists(false)
            }
        }
    }
    
    // read
    func fetchUserInfo(uesrID: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        let userRef = db.collection("User")
        
        userRef.document(userID).getDocument { document, error in
            if let error = error {
                completion(Result.failure(error))
            }
            guard let document = document,
                  document.exists,
                  let user = try? document.data(as: User.self)
            else { return }
            
            completion(Result.success(user))
        }
    }

}
