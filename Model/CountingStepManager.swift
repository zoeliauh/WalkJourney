//
//  CountingStepManager.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import CoreLocation

enum FirebaseError: Error {
    case documentError
}

class CountingStepManager {
    
    static let shared = CountingStepManager()
    
    lazy var db = Firestore.firestore()
    
    func fetchSteps(completion: @escaping (Result<[Location], Error>) -> Void) {
        
        db.collection(Collections.location.rawValue).order(
            by: "createdTime",
            descending: true
        ).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                var locations = [Location]()
                
                guard let querySnapshot = querySnapshot else { return }
                
                for document in querySnapshot.documents {
                                        
                    do {
                        if let location = try document.data(as: Location.self, decoder: Firestore.Decoder()) {
                            locations.append(location)
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
                
                completion(.success(locations))
            }
        }
    }
    
    func addNewLocation(latitude: CLLocationDegrees,
                        longitude: CLLocationDegrees,
                        completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = db.collection(Collections.location.rawValue).document()
        
        guard let uid = UserManager.shared.uid else { return }

        document.setData([
            "createdTime": Date().millisecondsSince1970,
            "location": [latitude, longitude],
            "id": uid
        ]) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("Success"))
            }
        }
    }
    
    func deleteLocation(location: Location, completion: @escaping (Result<String, Error>) -> Void) {
        
        db.collection(Collections.location.rawValue).document(location.id).delete { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success(location.id))
            }
        }
    }
    
    func updateLocation(location: Location, completion: @escaping (Result<String, Error>) -> Void) {
        
        db.collection(Collections.location.rawValue).document(location.id).updateData([
            "location": [11.23, 123.542]
        ])
    }
}
