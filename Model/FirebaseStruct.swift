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
    
    var id: String
    var location: Geopoint
    var createdTime: Int64?
    
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
    var createdTime: Int64?
    var id: String
    var latitude: [CLLocationDegrees]
    var longitude: [CLLocationDegrees]
    var date: String?
    var year: String?
    var month: String?
    var screenshot: String?
    
    enum CodingKeys: String, CodingKey {
        case numberOfSteps
        case durationOfTime
        case distanceOfWalk
        case createdTime
        case id
        case latitude
        case longitude
        case date
        case year
        case month
        case screenshot
    }
}
