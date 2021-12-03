//
//  UIButton+Extension.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/28.
//

import UIKit

extension UIButton {
    
    func buttonConfig(_ button: UIButton, cornerRadius: CGFloat) {
        
        button.layer.cornerRadius = cornerRadius
        button.backgroundColor = UIColor.C4
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 2.0
        button.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        button.layer.shadowColor = UIColor.black.cgColor
        button.clipsToBounds = true
        button.layer.masksToBounds = false
        button.layoutIfNeeded()
    }
}
