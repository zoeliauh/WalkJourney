//
//  RecordAfterWalking.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import CoreLocation

class RecordAfterWalking {
    
    static let shared = RecordAfterWalking()
    
    lazy var db = Firestore.firestore()

// read
    func fetchRecord(completion: @escaping(Result<[StepData], Error>) -> Void) {
        
        db.collection("stepData").order(by: "createdTime", descending: true).getDocuments()
        { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                var stepDatas = [StepData]()
                
                for document in querySnapshot!.documents {

                    do {
                        if let stepData = try document.data(as: StepData.self, decoder: Firestore.Decoder()) {
                            stepDatas.append(stepData)
                        }
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
                completion(.success(stepDatas))
            }
        }
    }
    
    // create
    func addNewRecord(distanceOfWalk: String, durationOfTime: String, numberOfStep: Int, screenshot: String, completion: @escaping(Result<String, Error>) -> Void) {
        
        let document = db.collection("stepData").document()
        
        document.setData([
        
                "id": document.documentID,
                "distanceOfWalk": distanceOfWalk,
                "durationOfTime": durationOfTime,
            "date": Date().millisecondsSince1970,
                "numberOfStep": numberOfStep,
                "screenshot": screenshot
        ]) { error in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                completion(.success("Success"))
            }
        }
    }
}
