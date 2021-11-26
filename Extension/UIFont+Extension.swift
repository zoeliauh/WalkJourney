//
//  UIFont+Extension.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/3.
//

import UIKit

private enum WJFontName: String {

    case regular = "KleeOne-Regular"
    
    case semiBold = "KleeOne-SemiBold"
}

extension UIFont {

    static func regular(size: CGFloat) -> UIFont? {

        return WJFont(.regular, size: size)
    }
    
    static func semiBold(size: CGFloat) -> UIFont? {
        
        return WJFont(.semiBold, size: size)
    }
    
    private static func WJFont(_ font: WJFontName, size: CGFloat) -> UIFont? {

        return UIFont(name: font.rawValue, size: size)
    }
}
