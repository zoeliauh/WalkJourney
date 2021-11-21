//
//  PublicPost.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/18.
//

import Foundation

struct PublicPost: Codable {
    
    var createdTime: Int64?
    var uid: String
    var postStatus: Int
    var screenshotURL: String
}
