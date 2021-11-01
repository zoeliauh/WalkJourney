//
//  RecordAfterWalking.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/22.
//
// swiftlint:disable line_length
// swiftlint:disable function_parameter_count

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage
import CoreLocation

class RecordManager {
    
    static let shared = RecordManager()
    
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
    
    // read certain day data
    func fetchDateRecord(calenderDay: String, completion: @escaping(Result<[StepData], Error>) -> Void) {
        
        db.collection("stepData").whereField("date", isEqualTo: calenderDay).getDocuments() { (querySnapshot, error) in
            
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
    
    // read certain month data
    func fetchMonthRecord(calenderDay: String, completion: @escaping(Result<[StepData], Error>) -> Void) {
        
        db.collection("stepData").whereField("month", isEqualTo: calenderDay).getDocuments()
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
    // read certain year data
    func fetchYearRecord(calenderDay: String, completion: @escaping(Result<[StepData], Error>) -> Void) {
        
        db.collection("stepData").whereField("Year", isEqualTo: calenderDay).getDocuments()
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
    func addNewRecord(distanceWalk: String, durationTime: String, numStep: Int, latitude: [CLLocationDegrees], longitude: [CLLocationDegrees], date: String, year: String, month: String, completion: @escaping(Result<String, Error>) -> Void) {
        
        let today = Date()
        let formatterDate = DateFormatter()
        let formatterYear = DateFormatter()
        let formatterMonth = DateFormatter()
        formatterDate.dateFormat = "yyyy.MM.dd"
        formatterYear.dateFormat = "yyyy"
        formatterMonth.dateFormat = "yyyy.MM"
        
        let document = db.collection("stepData").document()
        
        document.setData([
            
            "id": document.documentID,
            "distanceOfWalk": "\(distanceWalk) km",
            "durationOfTime": durationTime,
            "createdTime": Date().millisecondsSince1970,
            "numberOfSteps": numStep,
            "latitude": latitude,
            "longitude": longitude,
            "date": formatterDate.string(from: today),
            "year": formatterYear.string(from: today),
            "month": formatterMonth.string(from: today)
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
    // delete
    func deleteRecord(stepData: StepData) {
        
        db.collection("stepData").document(stepData.id).delete()
    }
}
