//
//  String+Extension.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/2.
//

import Foundation

extension String {
    
    static let positionPage = "首頁"
    
    static let recordPage = "足跡"
    
    static let galleryPage = "社群"
    
    static let profilePage = "會員"
    
    static let camera = "camera"
    
    static let cameraTitle = "Attach Photo"
    
    static let cameraMessage = "where would you like to attach a photo from"
    
    static let photoLibrary = "Photo Library"
    
    static let cancel = "Cancel"
    
    static let enterTextFieldPlaceholder = "輸入使用者名稱"
    
    static let searchFriendName = "請搜尋好友名稱"
    
    static let friendInvited = "好友邀請"
    
    static let friendLists = "好友名單"
    
    static let blockLists = "黑名單"
    
    static let challengeStart = "挑戰開始"
    
    static let letsGo = "開始囉"
    
    static let finish = "完成囉"
    
    static let addFriend = "加入好友"
    
    static let successfulSave = "儲存成功"
    
    static let confirmed = "確定"
    
    static let cancelMandarin = "取消"
    
    static let freeWalk = "漫遊足跡"
    
    static let challengeMap = "挑戰地圖"
    
    // Lottie name
    static let loading = "loading"
    
    static let profileLottie = "profile_lottie"
    
    static let walkingOutside = "walking_outside"
    
    static let starryBackground = "starry_background"
    
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
         return String(self[start...])
    }
}
