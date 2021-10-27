//
//  RecordAfterWalking.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage
import CoreLocation

class RecordAfterWalkingManager {
    
    static let shared = RecordAfterWalkingManager()
    
    lazy var db = Firestore.firestore()
    
    // read
    func fetchRecord(completion: @escaping(Result<[StepData], Error>) -> Void) {
        
        db.collection("stepData").order(by: "createdTime", descending: true).getDocuments()
        { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
            } else {
                
                var stepDatas = [StepData]()
                
                guard let querySnapshot = querySnapshot else { return }
                
                for document in querySnapshot.documents {
                    
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
    func addNewRecord(distanceOfWalk: String, durationOfTime: String, numberOfStep: Int, screenshot: UIImageView, completion: @escaping(Result<String, Error>) -> Void) {
        
        let document = db.collection("stepData").document()
        
        uploadScreenshot(imageView: screenshot, id: document.documentID) { url in
            
            document.setData([
                
                "id": document.documentID,
                "distanceOfWalk": "\(distanceOfWalk) km",
                "durationOfTime": durationOfTime,
                "createdTime": Date().millisecondsSince1970,
                "numberOfSteps": numberOfStep,
                "screenshot": url
            ]) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    completion(.success("Success"))
                }
            }
        }
        
        func uploadScreenshot (imageView: UIImageView, id: String, completion: @escaping (_ url: String) -> Void) {
            
            let storageRef = Storage.storage().reference().child("\(id).jpg")
            
            if let uploadData = imageView.image?.jpegData(compressionQuality: 0.5) {
                
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    
                    guard let metadata = metadata else {
                        completion("")
                        return
                    }
                    
                    storageRef.downloadURL(completion: { (url, error) in
                        
                        guard let downloadURL = url else {
                            completion("")
                            return
                        }
                        
                        completion(downloadURL.absoluteString)
                    })
                }
            } else {
                completion("")
            }
        }
    }
}
