//
//  FirebaseStruct.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/20.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation

struct Location: Codable {
    
    var id: String  // need to same as userID
    var location: Geopoint
    var createdTime: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case location
        case createdTime
    }
}

struct Geopoint: Codable {

    var longitude: Double
    var latitude: Double

    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
}

struct StepData: Codable {
    var numberOfSteps: Int
    var durationOfTime: String
    var distanceOfWalk: String
    var date: String
    var screenshot: String
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case numberOfSteps
        case durationOfTime
        case distanceOfWalk
        case date
        case screenshot
        case id
    }
}
