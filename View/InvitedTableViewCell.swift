//
//  InvitedTableViewCell.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/13.
//

import UIKit

class InvitedTableViewCell: UITableViewCell {
    
    lazy var profileImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage.system(.personPlacehloder)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    lazy var userName: UILabel = {
        
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.regular(size: 20)
        label.textAlignment = .left
        return label
    }()
    
    lazy var confirmedButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle(String.confirmed, for: .normal)
        button.titleLabel?.font = UIFont.semiBold(size: 18)
        button.buttonConfig(button, cornerRadius: 10)
        return button
    }()
    
    lazy var notNowButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle(String.cancelMandarin, for: .normal)
        button.titleLabel?.font = UIFont.semiBold(size: 18)
        button.buttonConfig(button, cornerRadius: 10)
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupProfileImageView()
        setupUserNameLabel()
        setupConfirmedButton()
        setupNotNowButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not beed implemented")
    }
}

// MARK: - UI design

extension InvitedTableViewCell {
    
    private func setupProfileImageView() {
        
        contentView.addSubview(profileImageView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 55),
            profileImageView.widthAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    private func setupUserNameLabel() {
        
        contentView.addSubview(userName)
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            userName.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 30),
            userName.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: -10),
            userName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setupConfirmedButton() {
        
        contentView.addSubview(confirmedButton)
        
        confirmedButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            confirmedButton.leadingAnchor.constraint(equalTo: userName.leadingAnchor),
            confirmedButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            confirmedButton.heightAnchor.constraint(equalToConstant: 30),
            confirmedButton.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func setupNotNowButton() {
        
        contentView.addSubview(notNowButton)
        
        notNowButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            notNowButton.leadingAnchor.constraint(equalTo: confirmedButton.trailingAnchor, constant: 40),
            notNowButton.bottomAnchor.constraint(equalTo: confirmedButton.bottomAnchor),
            notNowButton.heightAnchor.constraint(equalToConstant: 30),
            notNowButton.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
}
