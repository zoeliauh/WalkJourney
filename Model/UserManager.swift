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
    
    static let shared = UserManager()
    
    lazy var db = Firestore.firestore()
    
    let user = Auth.auth().currentUser
    
    private init() {}
    
    let userid: String = {
        if let user = Auth.auth().currentUser {
            return user.uid
        } else {
            return "0"
        }
    }()
    
    let userDisplayName: String = {
        
        if let user = Auth.auth().currentUser,
           let userName = user.displayName {
            print(userName)
            return userName
        } else {
            return "使用者"
        }
    }()
    
    let userEmail: String = {
        
        if let user = Auth.auth().currentUser,
           let userEmail = user.email {
            return userEmail
        } else {
            return "使用者信箱"
        }
    }()
    
    // create
    func createUserInfo() {
        let user = User(userID: userid,
                        username: userDisplayName,
                        email: userEmail, userImageURL: nil,
                        providerID: "Apple", blockLists: nil,
                        friendLists: nil)
        
        let userRef = db.collection(Collections.user.rawValue)
        
        do {
            try userRef.document(user.userID).setData(from: user)
        } catch {
            
            print("Fail to create user")
        }
    }
    
    // read
    func fetchUserInfo(uesrID: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        let userRef = db.collection(Collections.user.rawValue)
        
        userRef.document(userid).getDocument { document, error in
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
