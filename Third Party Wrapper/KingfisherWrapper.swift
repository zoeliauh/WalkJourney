//
//  UIImageView+Extension.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/27.
//

import UIKit
import Kingfisher

extension UIImageView {

    func loadImage(_ urlString: String?, placeHolder: UIImage? = nil) {

        guard urlString != nil else { return }
        
        let url = URL(string: urlString ?? "no urlString")

        self.kf.setImage(with: url, placeholder: placeHolder)
    }
}
