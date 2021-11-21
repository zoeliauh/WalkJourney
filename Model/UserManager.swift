//
//  UserManager.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/4.
//  swiftlint:disable line_length

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

class UserManager {
    
    static let shared = UserManager()
    
    lazy var db = Firestore.firestore()
    
    let user = Auth.auth().currentUser
    
    let uid = Auth.auth().currentUser?.uid
    
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
//            return "設定使用者名稱"
            return ""
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
    
    let userImageURL: String = "https://firebasestorage.googleapis.com/v0/b/walkjourney-8eaaf.appspot.com/o/profileImage%2F98DE3450-7B94-4548-9A52-1E45CBFAD4FD?alt=media&token=9e20bbb6-d39c-4027-b4f2-81f4cc03c55b"
    
    // create
    func createUserInfo() {
        let user = User(userID: userid,
                        username: userDisplayName,
                        email: userEmail, userImageURL: userImageURL,
                        providerID: "Apple", blockLists: nil,
                        friendLists: nil)
        
        let userRef = db.collection(Collections.user.rawValue)
        
        do {
            try userRef.document(user.userID).setData(from: user)
        } catch {
            
            print("Fail to create user")
        }
    }
    
    // fetch all user data
    func fetchAllUserInfo(completion: @escaping (Result<[User], Error>) -> Void) {
        
        db.collection(Collections.user.rawValue).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                var allUserInfo = [User]()
                
                guard let querySnapshot = querySnapshot else { return }
                
                for document in querySnapshot.documents {
                                        
                    do {
                        if let userInto = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                            allUserInfo.append(userInto)
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
    
                completion(.success(allUserInfo))
            }
        }
    }
    
    // fetch certain user Data
    func fetchUserInfo(uesrID: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        let userRef = db.collection(Collections.user.rawValue)
        
        userRef.document(uesrID).getDocument { document, error in
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
    
    // update userName or userImageURL
    func updateUserInfo(userID: String, url: String?, username: String?) {
        
        if url == nil {
        
            db.collection(Collections.user.rawValue).document(userID).updateData([
                "username": username as Any
            ])
        }
        
        if username == nil {
            
            db.collection(Collections.user.rawValue).document(userID).updateData([
                "userImageURL": url as Any
            ])
        }
    }
    // update user FriendList
    func updateFriendList(friendLists: [String]) {
        
        guard let uid = uid else { return }
        
        db.collection(Collections.user.rawValue).document(uid).updateData([
            "friendLists": friendLists as Any
        ])
    }
    
    // update other user FriendList
    func updateOtherUserFriendList(sender: String, friendLists: [String]) {
                
        db.collection(Collections.user.rawValue).document(sender).updateData([
            "friendLists": friendLists as Any
        ])
    }
    
    // update user blockLists
    func updateBlockList(blockLists: [String]) {
        
        guard let uid = uid else { return }
        
        db.collection(Collections.user.rawValue).document(uid).updateData([
            "blockLists": blockLists as Any
        ])
    }
    
//    // delete certain friend from friendLists
//    func deletefriend(friendID: String) {
//        
//        guard let uid = UserManager.shared.uid else { return }
//        
//        let documentRef = db.collection(Collections.invitation.rawValue)
//            .document(uid)
//        
//        documentRef.delete()
//    }
}
