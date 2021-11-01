//
//  FunnyMapTableViewCell.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/19.
//

import UIKit

class FunnyMapTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var shapeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        goButton.layer.cornerRadius = 20
    }
}
