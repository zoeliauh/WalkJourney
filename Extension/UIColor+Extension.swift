//
//  UIColor+Extension.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/18.
//

import UIKit

extension UIColor {

    static let C1 = UIColor(named: "C1")
    
    static let C2 = UIColor(named: "C2")
    
    static let C3 = UIColor(named: "C3")
    
    static let C4 = UIColor(named: "C4")
    
    static let C5 = UIColor(named: "C5")
    
    static let C6 = UIColor(named: "C6")
    
    static let D1 = UIColor(named: "D1")
    
    static func hexStringToUIColor(hex: String) -> UIColor {

        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
