//
//  FunnyMapTableViewCell.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/19.
//

import UIKit

class FunnyMapTableViewCell: UITableViewCell {
        
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var shapeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        goButton.layer.cornerRadius = 20
        goButton.layer.shadowOpacity = 0.3
        goButton.layer.shadowRadius = 2.0
        goButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        goButton.layer.shadowColor = UIColor.black.cgColor
    }
}
