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

class RecordManager {
    
    static let shared = RecordManager()
    
    lazy var db = Firestore.firestore()
    
    func fetchRecord(completion: @escaping(Result<[StepData], Error>) -> Void) {
        
        guard let uid = UserManager.shared.uid else { return }
        
        db.collection(Collections.stepData.rawValue)
            .whereField("id", isEqualTo: uid)
            .order(by: "createdTime", descending: true)
            .getDocuments { (querySnapshot, error) in
                
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
    
    func fetchDateRecord(calenderDay: String, completion: @escaping(Result<[StepData], Error>) -> Void) {
        
        guard let uid = UserManager.shared.uid else { return }
        
        db.collection(Collections.stepData.rawValue)
            .whereField("id", isEqualTo: uid)
            .whereField("date", isEqualTo: calenderDay)
            .getDocuments { (querySnapshot, error) in
                
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
    
    func fetchMonthRecord(calenderDay: String, completion: @escaping(Result<[StepData], Error>) -> Void) {
        
        guard let uid = UserManager.shared.uid else { return }
        
        db.collection(Collections.stepData.rawValue)
            .whereField("id", isEqualTo: uid)
            .whereField("month", isEqualTo: calenderDay)
            .getDocuments { (querySnapshot, error) in
                
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

    func fetchYearRecord(calenderDay: String, completion: @escaping(Result<[StepData], Error>) -> Void) {
        
        guard let uid = UserManager.shared.uid else { return }
        
        db.collection(Collections.stepData.rawValue)
            .whereField("id", isEqualTo: uid)
            .whereField("Year", isEqualTo: calenderDay)
            .getDocuments { (querySnapshot, error) in
                
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

    func fetchWalkBySelfRecord(completion: @escaping(Result<[StepData], Error>) -> Void) {
        
        guard let uid = UserManager.shared.uid else { return }
        
        db.collection(Collections.stepData.rawValue)
            .whereField("id", isEqualTo: uid)
            .whereField("screenshot", isEqualTo: "")
            .order(by: "createdTime", descending: true)
            .getDocuments { (querySnapshot, error) in
                
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
    
    func fetchChallengeRecord(completion: @escaping(Result<[StepData], Error>) -> Void) {
        
        guard let uid = UserManager.shared.uid else { return }
        
        db.collection(Collections.stepData.rawValue)
            .whereField("id", isEqualTo: uid)
            .whereField("screenshot", isNotEqualTo: "")
            .order(by: "screenshot")
            .order(by: "createdTime", descending: true)
            .getDocuments { (querySnapshot, error) in
                
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
    
    func addNewRecord(
        distanceWalk: String, durationTime: String, numStep: Int,
        latitude: [CLLocationDegrees], longitude: [CLLocationDegrees],
        screenshot: UIImageView,
        completion: @escaping(Result<String, Error>) -> Void
    ) {
        
        let document = db.collection(Collections.stepData.rawValue).document()
        
        guard let uid = UserManager.shared.uid else { return }
        
        uploadScreenshot(imageView: screenshot, id: document.documentID) { url in
            
            document.setData([
                
                "id": uid,
                "distanceOfWalk": "\(distanceWalk) km",
                "durationOfTime": durationTime,
                "createdTime": Date().millisecondsSince1970,
                "numberOfSteps": numStep,
                "latitude": latitude,
                "longitude": longitude,
                "date": Date.dateFormat(),
                "year": Date.yearFormat(),
                "month": Date.yearMonthFormat(),
                "screenshot": url
            ]) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                } else {
                    
                    completion(.success("Success"))
                }
            }
        }
    }
    
    func uploadScreenshot (imageView: UIImageView, id: String, completion: @escaping (_ url: String) -> Void) {
        
        let storageRef = Storage.storage().reference().child("\(id).jpg")
        
        if let uploadData = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            storageRef.putData(uploadData, metadata: nil) { (metadata, _) in
                
                guard metadata != nil else {
                    completion("")
                    return
                }
                
                storageRef.downloadURL(completion: { (url, _) in
                    
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

    func deleteRecord(createdTime: Int64) {
        
        guard let uid = UserManager.shared.uid else { return }
        
        db.collection(Collections.stepData.rawValue)
            .whereField("id", isEqualTo: uid)
            .whereField("createdTime", isEqualTo: createdTime)
            .getDocuments { snapshot, _ in
                
                guard let snapshot = snapshot else { return }
                
                snapshot.documents.forEach { snapshot in
                    snapshot.reference.delete()
                }
            }
    }
}
