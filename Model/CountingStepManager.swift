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

enum MasterError: Error {
    case youKnowNothingError(String)
}

// read
class CountingStepManager {
    
    static let shared = CountingStepManager()
    
    lazy var db = Firestore.firestore()
    
    // read
    func fetchSteps(completion: @escaping (Result<[Location], Error>) -> Void) {
        
        db.collection("locations").order(by: "createdTime", descending: true).getDocuments() {
            (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                var locations = [Location]()
                
                for document in querySnapshot!.documents {
                    
                    print(document.data())
                    
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
    
    // create
    func addNewLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = db.collection("locations").document()

        document.setData([
            "createdTime": Date().millisecondsSince1970,
            "location": [latitude, longitude],
            "id": document.documentID
        ]) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("Success"))
            }
        }
    }
    
    // delete
    func deleteLocation(location: Location, completion: @escaping (Result<String, Error>) -> Void) {
        
        db.collection("locations").document(location.id).delete() { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success(location.id))
            }
        }
    }
    
    // update
    func updateLocation(location: Location, completion: @escaping (Result<String, Error>) -> Void) {
        
        db.collection("locations").document(location.id).updateData([
            "location": [11.23, 123.542],
        ])
    }
}
