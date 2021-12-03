//
//  UIImage+Extenstion.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/25.
//
// swiftlint:disable identifier_name

import UIKit
import SwiftUI

enum ImageAsset: String {

    case backIcon
    case challengeIcon
    case crossMark
    case nextIcon
    case pullIcon
    case moreIcon
    case pawprint_Fill = "pawprint_fill"
    case pawprint
    case settingIcon
    case share
    case loginIcon
    case pushIcon
    
    // RouteMap
    case bubbleTeaLine = "bubble_tea_line"
    case bubbleTea = "bubble_tea"
    case heartLine = "heart_line"
    case heart = "heart"
    case mazeLine = "maze_line"
    case maze = "maze"
    case peaceFineLine = "peace_fine_line"
    case peace = "peace"
    case taipei101Line = "taipei_101_line"
    case taipei101 = "taipei_101"
    case taiwanGreen = "taiwan_green"
    case taiwanLine = "taiwan_line"
}

enum SystemImage: String {
    
    case map
    case mapFill = "map.fill"
    case socialGroup = "person.3"
    case socialGroupFill = "person.3.fill"
    case profile = "person.circle"
    case profileFill = "person.circle.fill"
    case personPlacehloder = "person.crop.circle"
    case photo
    case pencil
    case cameraFill = "camera.fill"
    case xMark = "xmark"
    case personFillXMark = "person.fill.xmark"
}

// swiftlint:enable identifier_name
extension UIImage {

    static func asset(_ asset: ImageAsset) -> UIImage? {

        return UIImage(named: asset.rawValue)
    }
    
    static func system(_ systemName: SystemImage) -> UIImage {

        return UIImage(systemName: systemName.rawValue) ?? UIImage()
    }
}
