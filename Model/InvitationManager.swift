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
        
        let userRef = db.collection(Collections.invation.rawValue)
        
        userRef.document().setData([
            
            "sender": uid as Any,
            "receiver": searchNameResult,
            "accepted": 0
        ])
    }
    
    // fetch all invitation data
    func fetchAllinvitationInfo(completion: @escaping (Result<[Invation], Error>) -> Void) {
        
        db.collection(Collections.invation.rawValue).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                var allInvitation = [Invation]()
                
                guard let querySnapshot = querySnapshot else { return }
                
                for document in querySnapshot.documents {
                                        
                    do {
                        if let allInvitation = try document.data(as: Invitation.self, decoder: Firestore.Decoder()) {
                            allInvitation.append(allInvitation)
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
    
                completion(.success(allUserInfo))
            }
        }
    }
}
