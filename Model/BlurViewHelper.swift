//
//  BlurViewHelper.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/18.
//

import UIKit

class BlurViewHelper: NSObject {
    
    static let shared = BlurViewHelper()
    
    func addBlurView(_ inView: UIView) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = inView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.75
        
        return blurEffectView
    }
}
