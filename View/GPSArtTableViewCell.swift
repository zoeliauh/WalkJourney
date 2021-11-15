//
//  GPSArtTableViewCell.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/15.
//

import UIKit

class GPSArtTableViewCell: UITableViewCell {
    
    lazy var gpsImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle")
//        imageView.layer.cornerRadius = imageView.frame.width / 2
        return imageView
    }()
    
    lazy var pinImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Icon_Pin")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        setupGPSImageView()
        setupPinImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not beed implemented")
    }
    
    private func setupGPSImageView() {
        
        contentView.addSubview(gpsImageView)
        
        gpsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gpsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            gpsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            gpsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            gpsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            gpsImageView.heightAnchor.constraint(equalToConstant: 450)
        ])
    }
    
    private func setupPinImageView() {
        
        contentView.addSubview(pinImageView)
        
        pinImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            pinImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            pinImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            pinImageView.widthAnchor.constraint(equalToConstant: 20),
            pinImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
