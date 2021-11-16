//
//  InvationManager.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/12.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

class InvitationManager {
    
    static let shared = InvitationManager()
    
    lazy var db = Firestore.firestore()
    
    let user = Auth.auth().currentUser
    
    let uid = Auth.auth().currentUser?.uid
    
    // create
    func createInvitationRequest(searchNameResult: String) {
        
        guard let uid = uid else { return }
        
        let userRef = db.collection(Collections.invitation.rawValue)
        
        userRef.document().setData([
            
            "sender": uid as Any,
            "receiver": searchNameResult,
            "accepted": 0
        ])
    }
    
    // fetch all invitation data
    func fetchAllInvitationInfo(completion: @escaping (Result<[Invitation], Error>) -> Void) {
        
        db.collection(Collections.invitation.rawValue).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                var allInvitations = [Invitation]()
                
                guard let querySnapshot = querySnapshot else { return }
                
                for document in querySnapshot.documents {
                    
                    do {
                        if let allInvitation = try document.data(as: Invitation.self, decoder: Firestore.Decoder()) {
                            allInvitations.append(allInvitation)
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
                
                completion(.success(allInvitations))
            }
        }
    }
    
    // fetch certain user invitation data
    func fetchUserInvitationInfo(completion: @escaping (Result<[Invitation], Error>) -> Void) {
        
        guard let uid = UserManager.shared.uid else { return }
        
        db.collection(Collections.invitation.rawValue)
            .whereField("sender", isEqualTo: uid)
            .getDocuments { (querySnapshot, error) in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    var userInvitations = [Invitation]()
                    
                    guard let querySnapshot = querySnapshot else { return }
                    
                    for document in querySnapshot.documents {
                        
                        do {
                            if let userInvitation = try document.data(as: Invitation.self, decoder: Firestore.Decoder()) {
                                userInvitations.append(userInvitation)
                            }
                            
                        } catch {
                            
                            completion(.failure(error))
                        }
                    }
                    
                    completion(.success(userInvitations))
                }
            }
    }
    
    func fetchInvitedRequest(completion: @escaping (Result<[Invitation], Error>) -> Void) {
        
        guard let uid = UserManager.shared.uid else { return }
        
        db.collection(Collections.invitation.rawValue)
            .whereField("receiver", isEqualTo: uid)
            .getDocuments { (snapshot, error) in
                
                if let error = error {
                    
                    completion(Result.failure(error))
                } else {
                    
                    guard let snapshot = snapshot else { return }
                    
                    let invitedRequest = snapshot.documents.compactMap { snapshot in
                        try? snapshot.data(as: Invitation.self)
                    }
                    
                    completion(Result.success(invitedRequest))
                }
            }
    }
    
    // update invitation request
    func updateInvitedStatus(sender: String) {
        
        guard let uid = uid else { return }
        
        db.collection(Collections.invitation.rawValue)
            .whereField("receiver", isEqualTo: uid)
            .whereField("sender", isEqualTo: sender)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    
                    print("update friendLists \(error)")
                } else {
                    
                    guard let querySnapshot = querySnapshot else { return }
                    for doc in querySnapshot.documents {
                        
                        doc.reference.updateData([
                            "accepted": 1
                        ])
                    }
                }
            }
    }
    
    // delete Invited Request
    func deleteInvitedRequest(sender: String) {
        
        guard let uid = UserManager.shared.uid else { return }
        
        db.collection(Collections.invitation.rawValue)
            .whereField("receiver", isEqualTo: uid)
            .whereField("sender", isEqualTo: sender)
            .whereField("accepted", isEqualTo: 0)
            .getDocuments { snapshot, error in
                
                if let error = error {
                    
                    print("delete InvitedRequest \(error)")
                } else {
                
                guard let snapshot = snapshot else { return }
                
                snapshot.documents.forEach { snapshot in
                    snapshot.reference.delete()
                }
            }
            }
    }
    
    // get real time data
    func getRealTimeFriendList() {
        
        
        
        
        
        
    }
    
}
