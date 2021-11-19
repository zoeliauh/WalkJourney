//
//  GPSArtTableViewCell.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/15.
//

import UIKit

class GPSArtTableViewCell: UITableViewCell {
    
    lazy var profileImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
        
        let label = UILabel()
        label.text = "userName"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    lazy var postTimeLabel: UILabel = {
        
        let label = UILabel()
        label.text = "2021.11.22"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var gpsImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.layer.cornerRadius = 16
        imageView.contentMode = .scaleAspectFill
        var blurEffectView: UIVisualEffectView!
        blurEffectView = BlurViewHelper.addBlurView(imageView)
        imageView.addSubview(blurEffectView)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var expandButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(named: "Icon_expand"), for: .normal)
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        setupProfileImageView()
        setupUserNameLabel()
        setupPostTimeLabel()
        setupGPSImageView()
        setupExpandButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not beed implemented")
    }
    
    private func setupProfileImageView() {
        
        contentView.addSubview(profileImageView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupUserNameLabel() {
        
        contentView.addSubview(userNameLabel)
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            userNameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 5)
        ])
    }
    
    private func setupPostTimeLabel() {
        
        contentView.addSubview(postTimeLabel)
        
        postTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            postTimeLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            postTimeLabel.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -5)
        ])
    }
    
    private func setupGPSImageView() {
        
        contentView.addSubview(gpsImageView)
        
        gpsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gpsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            gpsImageView.topAnchor.constraint(equalTo: postTimeLabel.bottomAnchor, constant: 10),
            gpsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            gpsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            gpsImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setupExpandButton() {
        
        gpsImageView.addSubview(expandButton)
        
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            expandButton.centerXAnchor.constraint(equalTo: gpsImageView.centerXAnchor),
            expandButton.centerYAnchor.constraint(equalTo: gpsImageView.centerYAnchor),
            expandButton.widthAnchor.constraint(equalToConstant: 70),
            expandButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}
