//
//  UIAlertAction+extension.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/29.
//

import UIKit

extension UIAlertAction {
    
    static func addAction(title: String, style: UIAlertAction.Style,
                          handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        
        let alertAction = UIAlertAction(title: title, style: style, handler: handler)
        return alertAction
    }
}
