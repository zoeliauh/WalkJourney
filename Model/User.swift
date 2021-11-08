//
//  User.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/4.
//

import Foundation

struct User: Codable {
    
    let userID: String
    var username: String?
    var email: String?
    var userImageURL: String?
    var providerID: String?
    var blockLists: [BlockLists]?
    var friendLists: [FriendLists]?
}

struct BlockLists: Codable {
    
    var blockFriends: String
}

struct FriendLists: Codable {
    
    var friends: String
}
