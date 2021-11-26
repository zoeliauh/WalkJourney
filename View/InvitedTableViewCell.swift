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
        
        button.setTitle("確認", for: .normal)
        buttonConfig(button)
        return button
    }()
    
    lazy var notNowButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("取消", for: .normal)
        buttonConfig(button)
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
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
    
    private func buttonConfig(_ button: UIButton) {
        
        button.titleLabel?.font = UIFont.semiBold(size: 18)
        button.backgroundColor = UIColor.C4
        button.layer.cornerRadius = 10
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 2.0
        button.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        button.layer.shadowColor = UIColor.black.cgColor
        button.clipsToBounds = true
        button.layer.masksToBounds = false
        button.layoutIfNeeded()
    }
    
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
